module Facebook
  class EstablishmentAssociationsController < ApplicationController
    load_resource :account, id_param: :account_id, class: '::Account'

    def new
      authorize! :manage, :facebook
      @account = @account.decorate
    end

    def create
      authorize! :manage, :facebook
      if @account.update account_params
        begin
          results = EstablishmentBootstrapper.new(@account).call
          if results.all? &:success?
            redirect_to account_path(@account), notice: 'Facebook onboarding is complete!'
          else
            flash[:warn] = warning_messages results
            redirect_to account_path @account
          end
        rescue => e
          logger.error "Error bootstrapping Facebook for account_id: #{@account.id} message: #{e.message}"
          logger.error(e.backtrace.join("\n"))
          redirect_to account_path(@account), alert: 'Facebook onboarding failed.'
        end
      else
        @account = @account.decorate
        render :new, alert: @account.errors.full_messages.join("\n")
      end
    end

    private

    def account_params
      params
        .require(:account)
        .permit(establishments_attributes: [:id, :facebook_page_id])
    end

    def warning_messages(results)
      failed_results = results.select { |r| !r.success? }
      list_items = failed_results.map { |r| "<li>#{r.failure_text}</li>" }.join
      "Facebook onboarding is complete, but we encountered the following issues:<br><ul>#{list_items}</ul>".html_safe
    end
  end
end
