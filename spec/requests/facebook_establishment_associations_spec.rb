require 'spec_helper'

describe 'Facebook Establishment associations' do
  let(:account) { create :account }
  let(:establishment) { create :establishment, name: 'Tavern 42', account: account }
  let(:user) { create :user, :manager, account: account }

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
    sign_in user
  end

  describe 'POST to /accounts/:account_id/facebook/establishment_associations', :vcr do
    let(:params) do
      {
        account: {
          establishments_attributes: {
            '0' => {
              'id' => establishment.id,
              'facebook_page_id' => '240936686640816'
            }
          }
        }
      }
    end

    context 'when all goes well' do
      it 'fetches and saves a page token, then creates a tab on the page' do
        post account_facebook_establishment_associations_path(account), {
          params: params
        }
        expect(response).to redirect_to account_path(account)
        follow_redirect!
        expect(response.body).to include 'Facebook onboarding is complete!'
      end
    end

    context 'when there are not enough likes on the page' do
      it 'informs the user of the issue' do
        post account_facebook_establishment_associations_path(account), {
          params: params
        }
        expect(response).to redirect_to account_path(account)
        follow_redirect!
        expect(response.body).to include "Facebook onboarding is complete, but we encountered the following issues:<br><ul><li>Failed to create a Menu tab on the Facebook page for Tavern 42. We can still make it happen, though. <a href=\"/facebook/overcoming_custom_tab_restrictions\">Click here for instructions.</a></li></ul>"
      end
    end
  end

  describe 'PUT to /accounts/:account_id/facebook/establishment_associations' do
    context 'when the establishment is found' do
      it 'sets facebook_page_id and returns 204' do
        put account_facebook_update_establishment_association_path(account), {
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
        put account_facebook_update_establishment_association_path(account), {
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
        put account_facebook_update_establishment_association_path(account), {
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
        put account_facebook_update_establishment_association_path(account), {
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
        put account_facebook_update_establishment_association_path(account), {
          params: {
            facebook_page_id: '240936686640816'
          },
          as: :json
        }

        expect(response).to have_http_status :bad_request
      end
    end
  end
end
