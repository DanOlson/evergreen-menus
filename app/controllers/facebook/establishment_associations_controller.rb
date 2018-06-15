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
          EstablishmentBootstrapper.new(@account).call
          redirect_to account_path(@account), notice: 'Facebook onboarding is complete!'
        rescue => e
          logger.error "Error bootstrapping Facebook for account_id: #{@account.id}"
          redirect_to account_path(@account), alert: 'Facebook onboarding failed. Page has fewer than 2000 likes?'
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
