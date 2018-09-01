require 'spec_helper'

module GoogleMyBusiness
  describe EstablishmentAssociationService do
    let(:account) { create :account }
    let(:establishment) { create :establishment, account: account }
    let(:user) { create :user, :manager, account: account }
    let(:ability) { Ability.new user }

    describe '#call' do
      let(:location_id) { 'accounts/111337701469104826106/locations/17679890243424107126' }
      let(:args) do
        {
          ability: ability,
          establishment_id: establishment.id,
          location_id: location_id
        }
      end
      let(:instance) do
        EstablishmentAssociationService.new(args)
      end

      before do
        allow(MenuBootstrapper).to receive :call
      end

      context 'when the establishment does not yet have a google_my_business_location_id' do
        it 'assigns the ID' do
          instance.call
          establishment.reload
          expect(establishment.google_my_business_location_id).to eq location_id
        end

        it 'bootstraps the online menu' do
          instance.call
          expect(MenuBootstrapper).to have_received :call
        end
      end

      context 'when an establishment is already associated' do
        let!(:other_establishment) do
          create :establishment, {
            account: account,
            google_my_business_location_id: location_id
          }
        end

        it 'assigns the ID to the given establishment' do
          instance.call
          establishment.reload
          expect(establishment.google_my_business_location_id).to eq location_id
        end

        it 'unsets the ID from the previous establishment' do
          instance.call
          other_establishment.reload
          expect(other_establishment.google_my_business_location_id).to be_nil
        end

        it 'bootstraps the OnlineMenu for the new establishment' do
          instance.call
          expect(MenuBootstrapper).to have_received(:call).with({
            establishment: establishment,
            gmb_location_id: location_id
          })
        end

        context 'and the given establishment_id is nil' do
          let(:args) do
            super().merge(establishment_id: nil)
          end

          it 'unsets the ID from the establishment' do
            expect(Establishment.exists?(google_my_business_location_id: location_id)).to eq true
            instance.call
            expect(Establishment.exists?(google_my_business_location_id: location_id)).to eq false
          end
        end

        context 'and the given establishment_id is empty' do
          let(:args) do
            super().merge(establishment_id: '')
          end

          it 'unsets the ID from the establishment' do
            expect(Establishment.exists?(google_my_business_location_id: location_id)).to eq true
            instance.call
            expect(Establishment.exists?(google_my_business_location_id: location_id)).to eq false
          end
        end
      end
    end
  end
end
