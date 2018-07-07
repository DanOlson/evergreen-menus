require 'spec_helper'

describe 'Facebook Establishment associations' do
  let(:account) { create :account }
  let(:establishment) { create :establishment, name: 'Tavern 42', account: account }
  let(:user) { create :user, :manager, account: account }

  before do
    sign_in user
  end

  describe 'POST to /accounts/:account_id/facebook/establishment_associations' do
    before do
      AuthToken
        .facebook_user
        .for_account(account)
        .create!({
          token_data: {
            access_token: 'user-access-token',
            token_type: 'bearer',
            expires_in: 5183999
          },
          access_token: 'user-access-token'
        })
    end

    context 'when the establishment is found' do
      it 'sets facebook_page_id and returns 204' do
        post account_facebook_establishment_associations_path(account), {
          params: {
            establishment_id: establishment.id,
            facebook_page_id: '240936686640816'
          },
          as: :json
        }
        establishment.reload
        expect(response).to have_http_status :no_content
        expect(establishment.facebook_page_id).to eq '240936686640816'
      end
    end

    context 'when other establishment is already assigned' do
      before do
        create :establishment, facebook_page_id: '240936686640816', account: account
      end

      it 'reassigns and returns 204' do
        post account_facebook_establishment_associations_path(account), {
          params: {
            establishment_id: establishment.id,
            facebook_page_id: '240936686640816'
          },
          as: :json
        }
        establishment.reload
        expect(response).to have_http_status :no_content
        expect(establishment.facebook_page_id).to eq '240936686640816'
      end
    end

    describe 'unsetting the facebook_page_id' do
      before do
        establishment.update! facebook_page_id: '240936686640816'
        establishment.reload
      end

      it 'unsets facebook_page_id and returns 204' do
        post account_facebook_establishment_associations_path(account), {
          params: {
            establishment_id: '',
            facebook_page_id: '240936686640816'
          },
          as: :json
        }
        establishment.reload
        expect(response).to have_http_status :no_content
        expect(establishment.facebook_page_id).to be_nil
      end
    end

    context 'when facebook_page_id is missing from params' do
      it 'returns 400' do
        post account_facebook_establishment_associations_path(account), {
          params: {
            establishment_id: establishment.id
          },
          as: :json
        }

        expect(response).to have_http_status :bad_request
      end
    end

    context 'when establishment_id is missing from params' do
      it 'returns 400' do
        post account_facebook_establishment_associations_path(account), {
          params: {
            facebook_page_id: '240936686640816'
          },
          as: :json
        }

        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'POST to /accounts/:accountId/facebook/menu_tabs' do
    it 'redirects to Facebook' do
      post account_facebook_menu_tabs_path(account), {
        params: {
          establishment_id: establishment.id
        }
      }
      facebook_app_id = ENV.fetch('FACEBOOK_CLIENT_ID') {
        APP_CONFIG[:facebook][:client_id]
      }
      redirect_uri = account_url(account)
      facebook_add_tab_url = "https://www.facebook.com/dialog/pagetab?app_id=#{facebook_app_id}&redirect_uri=#{redirect_uri}"
      expect(response).to redirect_to facebook_add_tab_url
    end

    context 'when no OnlineMenu exists for the given establishment' do
      it 'creates an OnlineMenu' do
        post account_facebook_menu_tabs_path(account), {
          params: {
            establishment_id: establishment.id
          }
        }
        establishment.reload
        expect(establishment.online_menu).to_not be_nil
      end
    end

    context 'when an OnlineMenu already exists for the given establishment' do
      before do
        establishment.create_online_menu!
      end

      it 'does not create an OnlineMenu' do
        expect {
          post account_facebook_menu_tabs_path(account), {
            params: {
              establishment_id: establishment.id
            }
          }
        }.to_not change(OnlineMenu, :count)
      end
    end
  end
end
