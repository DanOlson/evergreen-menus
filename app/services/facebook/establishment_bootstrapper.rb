module Facebook
  class EstablishmentBootstrapper
    attr_reader :account

    def initialize(account, facebook_service: nil)
      @account = account
      @facebook_service = facebook_service || default_fb_service
    end

    def call
      cleanup_stale_auth_tokens
      integrate
    end

    private

    def cleanup_stale_auth_tokens
      establishment_ids = @account
        .establishments
        .where(facebook_page_id: [nil, ''])
        .select(:id)
      AuthToken.where(establishment_id: establishment_ids).destroy_all
    end

    def integrate
      @account.establishments.each do |e|
        if e.facebook_page_id.present?
          fetch_and_save_token e
          create_tab e
        end
      end
    end

    def fetch_and_save_token(establishment)
      token = @facebook_service.page_access_token establishment
      AuthToken
        .facebook_page
        .for_establishment(establishment)
        .create({
          token_data: { access_token: token },
          access_token: token
        })
    end

    def create_tab(establishment)
      @facebook_service.create_tab establishment
    end

    def default_fb_service
      Service.new account: @account
    end
  end
end
