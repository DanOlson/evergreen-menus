require 'spec_helper'

describe 'associating establishments with GMB locations', :vcr do
  let(:account) { create :account, google_my_business_account_id: 'accounts/111337701469104826106' }
  let(:establishment) { create :establishment, account: account }
  let(:token) { 'mock-access-token' }
  let(:location_id) { 'accounts/111337701469104826106/locations/17679890243424107126' }
  let(:user) { create :user, :manager, account: account }

  before do
    sign_in user
    AuthToken.google.for_account(account).create!({
      access_token: token,
      token_data: {
        access_token: token,
        refresh_token: 'qwer',
        expires_in: 3600,
        token_type: 'Bearer'
      }
    })
  end

  context 'when not authorized' do
    context 'to access the account' do
      let(:user) { create :user, :manager } # Other account

      it 'returns 401' do
        post account_google_my_business_establishment_associations_path(account), {
          params: {
            establishment_id: establishment.id,
            location_id: location_id
          },
          as: :json
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'to manage google_my_business' do
      let(:user) { create :user, account: account }

      it 'returns 401' do
        post account_google_my_business_establishment_associations_path(account), {
          params: {
            establishment_id: establishment.id,
            location_id: location_id
          },
          as: :json
        }
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'successful association' do
    it 'assigns google_my_business_location_id on the establishment' do
      post account_google_my_business_establishment_associations_path(account), {
        params: {
          establishment_id: establishment.id,
          location_id: location_id
        },
        as: :json
      }
      establishment.reload
      expect(establishment.google_my_business_location_id).to eq location_id
    end

    it 'creates an OnlineMenu' do
      expect {
        post account_google_my_business_establishment_associations_path(account), {
          params: {
            establishment_id: establishment.id,
            location_id: location_id
          },
          as: :json
        }
      }.to change(OnlineMenu, :count).by 1
    end

    it 'returns 204' do
      post account_google_my_business_establishment_associations_path(account), {
        params: {
          establishment_id: establishment.id,
          location_id: location_id
        },
        as: :json
      }
      expect(response).to have_http_status :no_content
    end
  end

  describe 'disassociation' do
    let!(:establishment) do
      est = create :establishment, {
        account: account,
        google_my_business_location_id: location_id
      }
      create :online_menu, establishment: est
      est
    end

    it 'unsets google_my_business_location_id on the establishment' do
      post account_google_my_business_establishment_associations_path(account), {
        params: {
          establishment_id: '',
          location_id: location_id
        },
        as: :json
      }
      establishment.reload
      expect(establishment.google_my_business_location_id).to be_nil
    end

    it 'does not delete the OnlineMenu' do
      expect {
        post account_google_my_business_establishment_associations_path(account), {
          params: {
            establishment_id: '',
            location_id: location_id
          },
          as: :json
        }
      }.to_not change(OnlineMenu, :count)
    end
  end
end
