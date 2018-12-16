require 'spec_helper'

describe 'storing attempted location when logged out' do
  let!(:user) { create :user, :account_admin, account: account }
  let(:account) { create :account, :with_subscription }
  let(:establishment) { create :establishment, account: account }

  context 'with web menu preview' do
    let(:web_menu) { create :web_menu, :with_lists, establishment: establishment }

    before do
      get account_establishment_web_menu_preview_path(account, establishment, web_menu, format: 'html'), params: {
        web_menu: {
          name: web_menu.name
        }
      }
    end

    it 'does not remember the location' do
      expect(response).to redirect_to new_user_session_path
      post user_session_path, params: {
        user: {
          username: user.username,
          password: user.password
        }
      }
      expect(response).to redirect_to account_path(account)
    end
  end

  context 'with print menu preview' do
    let(:menu) { create :menu, :with_lists, establishment: establishment }

    before do
      get account_establishment_menu_preview_path(account, establishment, menu, format: 'html'), params: {
        menu: {
          name: menu.name
        }
      }
    end

    it 'does not remember the location' do
      expect(response).to redirect_to new_user_session_path
      post user_session_path, params: {
        user: {
          username: user.username,
          password: user.password
        }
      }
      expect(response).to redirect_to account_path(account)
    end
  end

  context 'with digital display menu preview' do
    let(:menu) { create :digital_display_menu, establishment: establishment }

    before do
      get account_establishment_digital_display_menu_preview_path(account, establishment, menu, format: 'html'), params: {
        digital_display_menu: {
          name: menu.name
        }
      }
    end

    it 'does not remember the location' do
      expect(response).to redirect_to new_user_session_path
      post user_session_path, params: {
        user: {
          username: user.username,
          password: user.password
        }
      }
      expect(response).to redirect_to account_path(account)
    end
  end

  context 'with online menu preview' do
    let(:menu) { create :online_menu, establishment: establishment }

    before do
      get account_establishment_online_menu_preview_path(account, establishment, menu, format: 'html'), params: {
        online_menu: {
          name: menu.name
        }
      }
    end

    it 'does not remember the location' do
      expect(response).to redirect_to new_user_session_path
      post user_session_path, params: {
        user: {
          username: user.username,
          password: user.password
        }
      }
      expect(response).to redirect_to account_path(account)
    end
  end
end
