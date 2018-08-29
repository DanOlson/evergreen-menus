require 'spec_helper'

describe AccountsController do
  describe 'PATCH to #update' do
    let(:account) { create :account }
    let(:user) { create :user, :manager, account: account }

    before do
      sign_in user
    end

    context 'when updating account and payment info' do
      it 'updates the account' do
        update_service = instance_double AccountUpdateService, success?: true
        expect(AccountUpdateService).to receive(:call).with(
          hash_including(
            :ability,
            account: account,
            name: 'Foobar',
            stripe: {
              source: 'tok_sometok'
            }
          )
        ).and_return update_service
        patch :update, params: {
          id: account.id,
          account: { name: 'Foobar' },
          stripe: { source: 'tok_sometok' }
        }
        expect(response).to redirect_to account_path(account)
      end
    end

    context 'when the account is not valid' do
      before do
        update_service = instance_double AccountUpdateService, {
          success?: false,
          error_messages: ["Name can't be blank"]
        }
        expect(AccountUpdateService).to receive(:call) { update_service }
        patch :update, params: {
          id: account.id,
          account: { name: nil }
        }
      end

      it 'renders :edit' do
        expect(response).to render_template :edit
      end

      it 'shows a flash message' do
        expect(flash[:alert]).to eq "Name can't be blank"
      end
    end
  end
end
