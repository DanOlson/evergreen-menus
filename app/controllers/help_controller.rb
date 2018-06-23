class HelpController < ApplicationController
  def facebook_custom_tab_restrictions
    @facebook_app_id = ENV.fetch('FACEBOOK_CLIENT_ID') {
      APP_CONFIG[:facebook][:client_id]
    }
  end
end
