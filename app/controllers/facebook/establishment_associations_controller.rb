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
            failed_results = results.select { |r| !r.success? }
            flash[:warn] = "Facebook onboarding is complete, but we encountered the following issues:<br>#{failed_results.map(&:failure_text).join('<br>')}".html_safe
            redirect_to account_path(@account)
          end
        rescue => e
          logger.error "Error bootstrapping Facebook for account_id: #{@account.id} message: #{e.message}"
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
  end
end
