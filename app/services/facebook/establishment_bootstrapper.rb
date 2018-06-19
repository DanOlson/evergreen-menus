module Facebook
  class EstablishmentBootstrapper
    attr_reader :account

    def initialize(account, facebook_service: nil)
      @account = account
      @facebook_service = facebook_service || default_fb_service
    end

    ###
    # TODO: Handle errors, return some status object
    def call
      cleanup_stale_auth_tokens
      integrate
    end

    private

    def cleanup_stale_auth_tokens
      AuthToken
        .facebook_page
        .for_account(@account)
        .destroy_all
    end

    def integrate
      @account.establishments.each do |e|
        if e.facebook_page_id.present?
          fetch_and_save_token e
          ensure_menu_exists e
          create_tab e
        end
      end
    end

    def fetch_and_save_token(establishment)
      page = @facebook_service.page establishment
      token = page.access_token
      AuthToken
        .facebook_page
        .for_establishment(establishment)
        .create({
          token_data: { access_token: token },
          access_token: token
        })
    end

    def ensure_menu_exists(establishment)
      establishment.create_google_menu! unless establishment.google_menu
    end

    def create_tab(establishment)
      @facebook_service.create_tab establishment
    end

    def default_fb_service
      Service.new account: @account
    end
  end
end
