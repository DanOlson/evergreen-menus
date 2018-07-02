module Facebook
  class EstablishmentAssociationsController < ApplicationController
    load_and_authorize_resource :account, id_param: :account_id, class: '::Account'

    def new
      authorize! :manage, :facebook
      @account = @account.decorate
    end

    def create
      authorize! :manage, :facebook
      if !(params.key?(:facebook_page_id) && params.key?(:establishment_id))
        head :bad_request and return
      end

      EstablishmentAssociationService.new({
        ability: current_ability,
        facebook_page_id: params[:facebook_page_id],
        establishment_id: params[:establishment_id]
      }).call

      head :no_content
    end
  end
end
