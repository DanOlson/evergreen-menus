class OauthFacebookController < ApplicationController
  delegate :account, to: :current_user

  def authorize
    redirect_to service.authorization_uri({
      establishment_id: params[:establishment_id]
    })
  end

  def callback
    if params[:error]
      redirect_to account_path(account), alert: 'Access denied'
    else
      establishment = find_establishment
      service.exchange code: params[:code], establishment: establishment
      redirect_to edit_account_establishment_path(account, establishment), notice: 'Facebook authorization was successful'
    end
  end

  private

  def service
    FacebookOauthService.new
  end

  def find_establishment
    id = Base64.urlsafe_decode64(params[:state]).split('-').last
    Establishment.accessible_by(current_ability).find(id)
  end
end
