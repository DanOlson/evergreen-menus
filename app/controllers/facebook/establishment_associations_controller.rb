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

      relation = @account
        .establishments
        .accessible_by(current_ability)

      prev_est = relation.find_by(facebook_page_id: params[:facebook_page_id])
      new_est = relation.find_by(id: params[:establishment_id])

      Establishment.transaction do
        prev_est.update(facebook_page_id: nil) if prev_est
        new_est.update(facebook_page_id: params[:facebook_page_id]) if new_est
      end

      head :no_content
    end
  end
end
