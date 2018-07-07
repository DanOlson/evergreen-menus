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
      @establishment.create_online_menu! unless @establishment.online_menu
      redirect_to facebook_add_tab_url
    end

    private

    def facebook_add_tab_url
      facebook_app_id = ENV.fetch('FACEBOOK_CLIENT_ID') {
        APP_CONFIG[:facebook][:client_id]
      }
      redirect_uri = account_url @account
      "https://www.facebook.com/dialog/pagetab?app_id=#{facebook_app_id}&redirect_uri=#{redirect_uri}"
    end
  end
end
