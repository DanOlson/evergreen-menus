module Facebook
  class EstablishmentAssociationsController < ApplicationController
    load_and_authorize_resource :account, id_param: :account_id, class: '::Account'
    load_and_authorize_resource :establishment, through: :account, id_param: :establishment_id, class: '::Establishment', only: :tab

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

    def tab
      authorize! :manage, :facebook
      result = MenuTabBootstrapper.new(@establishment).call
      if result.success?
        head :no_content
      else
        head :internal_server_error
      end
    end
  end
end
