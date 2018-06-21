module Facebook
  class EstablishmentBootstrapper
    attr_reader :account

    def initialize(account, facebook_service: nil, logger: Rails.logger)
      @account = account
      @logger = logger
      @facebook_service = facebook_service || default_fb_service
    end

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
      @account.establishments.map do |e|
        result = Result.new e
        if e.facebook_page_id.present?
          fetch_and_save_token e, result.save_token
          ensure_menu_exists e, result.ensure_menu
          create_tab e, result.create_tab
        end

        result
      end
    end

    def fetch_and_save_token(establishment, operation)
      begin
        page = @facebook_service.page establishment
        @logger.info "Page #{page.id} for establishment #{establishment.id} has #{page.fan_count} likes"
        token = page.access_token
      rescue => e
        message = 'Failed to get a page token'
        @logger.error message
        operation.fail message, e
        return
      end

      begin
        AuthToken
          .facebook_page
          .for_establishment(establishment)
          .create!({
            token_data: { access_token: token },
            access_token: token
          })
      rescue => e
        message = 'Failed to save the page token'
        @logger.error message
        operation.fail message, e
        return
      end
    end

    def ensure_menu_exists(establishment, operation)
      establishment.create_google_menu! unless establishment.google_menu
    rescue => e
      message = 'Failed to create the Evergreen Facebook menu'
      @logger.error message
      operation.fail message, e
    end

    def create_tab(establishment, operation)
      @facebook_service.create_tab establishment
    rescue => e
      message = 'Failed to create a Menu tab on the Facebook page'
      @logger.error message
      operation.fail message, e
    end

    def default_fb_service
      Service.new account: @account
    end

    class Operation
      attr_reader :exception

      def initialize
        @success = true
      end

      def success?
        @success
      end

      def succeed
        @success = true
      end

      def fail(reason, exception)
        @success = false
        @reason = reason
        @exception = exception
      end

      def failure_text
        @reason
      end
    end

    class Result
      attr_reader :establishment, :save_token, :ensure_menu, :create_tab

      def initialize(establishment)
        @establishment = establishment
        @save_token    = Operation.new
        @ensure_menu   = Operation.new
        @create_tab    = Operation.new
        @operations = [save_token, ensure_menu, create_tab]
      end

      def success?
        @operations.all? &:success?
      end

      def failure_text
        return if success?
        text = "#{failed_operation.failure_text} for #{establishment.name}"
        if failed_operation == create_tab
          text += '. We can still make it happen, though. <a href="/facebook/overcoming_custom_tab_restrictions">Click here for instructions.</a>'
        end
        text
      end

      def failure_cause
        return if success?
        failed_operation.exception
      end

      private

      def failed_operation
        @operations.find { |op| !op.success? }
      end
    end
  end
end
