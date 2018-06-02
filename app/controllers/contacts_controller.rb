class ContactsController < ApplicationController
  ACCESS_CONTROL_ALLOW_HEADERS = 'Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token'.freeze
  ACCESS_CONTROL_ALLOW_METHODS = 'POST, OPTIONS'.freeze
  ALLOWED_ORIGINS = ['https://evergreenmenus.com', 'http://localhost:4000']

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    logger.info 'Received contact request form submission'
    logger.info "origin: #{origin}"
    if allowed?
      send_email
      set_cors_headers
      head :created
    else
      head :unauthorized
    end
  end

  private

  def send_email
    if contact_params.key?(:newsletter)
      logger.info 'BOT DETECTED! Skipping form submission.'
    else
      ContactFormMailer.contact_form_email(contact_params).deliver_now
    end
  end

  def contact_params
    params[:contact].permit(:name, :email, :message, :newsletter) # newsletter == honeypot
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
