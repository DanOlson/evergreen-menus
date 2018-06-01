class ContactsController < ApplicationController
  ACCESS_CONTROL_ALLOW_HEADERS = 'Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token'.freeze
  ACCESS_CONTROL_ALLOW_METHODS = 'POST, OPTIONS'.freeze
  ALLOWED_ORIGINS = ['https://evergreenmenus.com', 'localhost:4000']

  skip_before_action :authenticate_user!

  def create
    logger.info 'Received contact request form submission'
    if allowed?
      ContactFormMailer.contact_form_email(contact_params).deliver_now
      set_cors_headers
      head :created
    else
      head :unauthorized
    end
  end

  private

  def contact_params
    params[:contact].permit(:name, :email, :message)
  end

  def allowed?
    ALLOWED_ORIGINS.include? origin
  end

  def set_cors_headers
    response.set_header 'access-control-allow-headers', ACCESS_CONTROL_ALLOW_HEADERS
    response.set_header 'access-control-allow-credentials', 'true'
    response.set_header 'access-control-allow-methods', ACCESS_CONTROL_ALLOW_METHODS
    response.set_header 'access-control-allow-origin', origin
  end

  def origin
    request.headers['Origin']
  end
end
