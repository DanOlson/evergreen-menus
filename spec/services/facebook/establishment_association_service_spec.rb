require 'spec_helper'

module Facebook
  describe EstablishmentAssociationService do
    let(:account) { create :account }
    let(:establishment) { create :establishment, account: account }
    let(:user) { create :user, :manager, account: account }
    let(:ability) { Ability.new user }

    describe '#call' do
      let(:args) do
        {
          ability: ability,
          establishment_id: establishment.id,
          facebook_page_id: '240936686640816'
        }
      end
      let(:instance) do
        EstablishmentAssociationService.new(args)
      end

      context 'with a simple, greenfield happy-path association' do
        it 'sets facebook_page_id on the establishment' do
          instance.call
          establishment.reload
          expect(establishment.facebook_page_id).to eq '240936686640816'
        end
      end

      context 'when another establishment is already assigned' do
        let!(:other_est) do
          create :establishment, facebook_page_id: '240936686640816', account: account
        end

        it 'reassigns the facebook_page_id to the given establishment' do
          instance.call
          establishment.reload
          other_est.reload

          expect(establishment.facebook_page_id).to eq '240936686640816'
          expect(other_est.facebook_page_id).to eq nil
        end

        context 'and the establishment has a FB page token' do
          before do
            AuthToken
              .facebook_page
              .for_establishment(other_est)
              .create!({
                token_data: { "access_token" => "a-mock-page-token" },
                access_token: 'a-mock-page-token',
              })
          end

          it 'reassociates the token to the given establishment' do
            instance.call

            reassigned_token = AuthToken
              .facebook_page
              .for_establishment(establishment)
              .first

            expect(reassigned_token).to_not be_nil
            expect(reassigned_token.access_token).to eq 'a-mock-page-token'

            expect(
              AuthToken
                .facebook_page
                .for_establishment(other_est)
                .first
            ).to eq nil
          end
        end

        context "and we're disassociating the page from any establishment" do
          let(:args) { super().merge(establishment_id: '') }

          it 'removes the facebook_page_id from the establishment' do
            instance.call

            other_est.reload
            expect(other_est.facebook_page_id).to eq nil
          end

          context 'and the existing establishment has a FB page token' do
            before do
              AuthToken
                .facebook_page
                .for_establishment(other_est)
                .create!({
                  token_data: { "access_token" => "a-mock-page-token" },
                  access_token: 'a-mock-page-token',
                })
            end

            it 'deletes the token' do
              expect {
                instance.call
              }.to change(AuthToken, :count).by -1

              expect(
                AuthToken
                  .facebook_page
                  .for_establishment(other_est)
                  .first
              ).to be_nil
            end
          end
        end
      end
    end
  end
end
