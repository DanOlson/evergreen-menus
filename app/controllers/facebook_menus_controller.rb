class FacebookMenusController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!, only: :show

  def show
    parsed_request = Facebook::SignedRequest.new(params[:signed_request]).parse
    establishment = Establishment.find_by facebook_page_id: parsed_request['page']['id']
    if !establishment
      render :not_found, layout: false, status: :not_found
    elsif !establishment.account.active?
      render :not_found, layout: false, status: :payment_required
    else
      @google_menu = establishment.google_menu
      render :show, layout: 'facebook_menu_tab'
    end
  end
end
