module GoogleMyBusiness
  class EstablishmentAssociationsController < ApplicationController
    load_resource :account, id_param: :account_id, class: '::Account'

    def new
      authorize! :manage, :google_my_business
      @account = @account.decorate
    end

    def create
      establishment = find_establishment
      authorize! :manage, :google_my_business
      if establishment.update establishment_params
        MenuBootstrapper.call({
          establishment: establishment,
          gmb_location_id: establishment.google_my_business_location_id
        })
        head :no_content
      else
        @account = @account.decorate
        render :new, alert: @account.errors.full_messages.join("\n")
      end
    end

    private

    def find_establishment
      @account
        .establishments
        .accessible_by(current_ability)
        .find_by! id: params[:establishment_id]
    end

    def establishment_params
      { google_my_business_location_id: params.require(:location_id) }
    end

    def account_params
      params
        .require(:account)
        .permit(establishments_attributes: [:id, :google_my_business_location_id])
    end
  end
end
