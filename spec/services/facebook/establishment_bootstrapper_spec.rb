require 'spec_helper'

module Facebook
  describe EstablishmentBootstrapper do
    let(:account) { create :account }
    let(:page) do
      Page.new('access_token' => 'mock_page_token')
    end
    let(:mock_facebook_service) do
      double(Service, {
        page: page,
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

        it 'returns an array of results' do
          res1, res2 = instance.call
          expect(res1.establishment).to eq establishment1
          expect(res2.establishment).to eq establishment2

          expect(res1).to be_success
          expect(res2).to be_success
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

        it 'creates an online_menu for the establishment' do
          expect {
            instance.call
          }.to change(OnlineMenu, :count).by 1
          establishment1.reload
          expect(establishment1.online_menu).to_not eq nil
        end

        it 'creates a tab on the facebook page' do
          instance.call
          expect(mock_facebook_service).to have_received(:create_tab).with establishment1
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
        end

        context 'when there is already an online_menu for the establishment' do
          before do
            OnlineMenu.create! establishment: establishment1
          end

          it 'does not create an online_menu' do
            expect {
              instance.call
            }.to_not change OnlineMenu, :count
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
            token_count = AuthToken
              .for_establishment(establishment2)
              .where(provider: 'somewhere-else')
              .count
            expect(token_count).to eq 1
          end
        end
      end

      describe 'bootstrap failure' do
        let!(:establishment) do
          create :establishment, account: account, name: 'Est. 1923', facebook_page_id: '12345'
        end
        let(:exception) { UnauthorizedError.new }

        context 'when fetching the page token fails' do
          before do
            allow(mock_facebook_service)
              .to receive(:page)
              .and_raise(exception)
          end

          it 'identifies the cause of the problem' do
            result = instance.call.first
            expect(result.establishment).to eq establishment
            expect(result.failure_text).to eq 'Failed to get a page token for Est. 1923'
            expect(result.failure_cause).to eq exception
            expect(result.save_token).to_not be_success
            expect(result.save_token.failure_text).to eq 'Failed to get a page token'
            expect(result.save_token.exception).to eq exception
          end
        end

        context 'when saving the page token fails' do
          ###
          # No access_token :(
          before do
            allow(mock_facebook_service)
              .to receive(:page)
              .and_return Page.new
          end

          it 'identifies the cause of the problem' do
            result = instance.call.first
            expect(result.establishment).to eq establishment
            expect(result.failure_text).to eq 'Failed to save the page token for Est. 1923'
            expect(result.failure_cause).to be_an ActiveRecord::RecordInvalid
            expect(result.save_token).to_not be_success
            expect(result.save_token.failure_text).to eq 'Failed to save the page token'
            expect(result.save_token.exception).to be_an ActiveRecord::RecordInvalid
          end
        end

        context 'when creating the tab fails' do
          before do
            allow(mock_facebook_service)
              .to receive(:create_tab)
              .and_raise(StandardError, 'the failure reason')
          end

          it 'identifies the failure reason' do
            result = instance.call.first
            expect(result.establishment).to eq establishment
            expect(result.failure_text).to eq 'Failed to create a Menu tab on the Facebook page for Est. 1923. We can still make it happen, though. <a href="/facebook/overcoming_custom_tab_restrictions">Click here for instructions.</a>'
            expect(result.failure_cause).to be_a StandardError
            expect(result.create_tab).to_not be_success
            expect(result.create_tab.failure_text).to eq 'Failed to create a Menu tab on the Facebook page'
            expect(result.create_tab.exception).to be_a StandardError
          end
        end
      end
    end
  end
end
