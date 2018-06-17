require 'spec_helper'

module Facebook
  describe EstablishmentBootstrapper do
    let(:account) { create :account }
    let(:mock_facebook_service) do
      double(Service, {
        page_access_token: 'mock_page_token',
        create_tab: nil
      })
    end
    let(:instance) do
      EstablishmentBootstrapper.new account, facebook_service: mock_facebook_service
    end

    describe '#call' do
      context 'when there are multiple establishments on the account' do
        let(:establishment1) { create :establishment, name: 'a', facebook_page_id: '12345' }
        let(:establishment2) { create :establishment, name: 'b' }

        before do
          establishment1.update(account: account)
          establishment2.update(account: account)
          establishment1.reload
          establishment2.reload
        end

        context 'and there is a stale page token for an establishment that has been unlinked' do
          before do
            AuthToken
              .facebook_page
              .for_establishment(establishment2)
              .create!({
                token_data: '{}',
                access_token: 'asdf'
              })
          end

          it 'the token is deleted' do
            instance.call
            expect(AuthToken.facebook_page.for_establishment(establishment2).count).to eq 0
          end

          it 'creates a new AuthToken for the establishment with a facebook page' do
            instance.call
            token = AuthToken
              .facebook_page
              .for_establishment(establishment1)
              .first
            expect(token.access_token).to eq 'mock_page_token'
            expect(token.token_data).to eq('access_token' => 'mock_page_token')
          end

          it 'creates a google_menu for the establishment' do
            expect {
              instance.call
            }.to change(GoogleMenu, :count).by 1
            establishment1.reload
            expect(establishment1.google_menu).to_not eq nil
          end

          it 'creates a tab on the facebook page' do
            instance.call
            expect(mock_facebook_service).to have_received(:create_tab).with establishment1
          end
        end

        context 'when there is already a google_menu for the establishment' do
          before do
            GoogleMenu.create! establishment: establishment1
          end

          it 'does not create a google_menu' do
            expect {
              instance.call
            }.to_not change GoogleMenu, :count
          end
        end

        context 'when there is some other token for an establishment that has been unlinked' do
          before do
            AuthToken
              .for_establishment(establishment2)
              .create!({
                provider: 'somewhere-else',
                token_data: '{}',
                access_token: 'asdf'
              })
          end

          it 'the token is not deleted' do
            instance.call
            expect(AuthToken.for_establishment(establishment2).where(provider: 'somewhere-else').count).to eq 1
          end
        end
      end
    end
  end
end
