module GoogleMyBusiness
  class EstablishmentAssociationsController < ApplicationController
    load_resource :account, id_param: :account_id, class: '::Account'

    def new
      authorize! :manage, :google_my_business
      @account = @account.decorate
    end

    def create
      authorize! :update, @account
      authorize! :manage, :google_my_business

      EstablishmentAssociationService.new({
        ability: current_ability,
        establishment_id: params[:establishment_id],
        location_id: params[:location_id]
      }).call

      head :no_content
    rescue CanCan::AccessDenied
      head :unauthorized
    end
  end
end
