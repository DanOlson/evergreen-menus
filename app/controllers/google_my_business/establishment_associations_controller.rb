module GoogleMyBusiness
  class EstablishmentAssociationsController < ApplicationController
    load_resource :account, id_param: :account_id, class: '::Account'

    def new
      authorize! :manage, :google_my_business
      @account = @account.decorate
    end

    def create
      authorize! :manage, :google_my_business
      @account = @account.decorate
      if @account.update account_params
        redirect_to account_path(@account), notice: 'Google My Business onboarding is complete!'
      else
        render :new, alert: @account.errors.full_messages.join("\n")
      end
    end

    private

    def account_params
      params
        .require(:account)
        .permit(establishments_attributes: [:id, :google_my_business_location_id])
    end
  end
end
