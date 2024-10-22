class ApplicationController < ActionController::Base
  MESSAGE_UNAUTHORIZED = 'You are not authorized to access this page.'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :store_requested_location, if: :storable_location?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :after_sign_in_path_for, :entitled_to?

  rescue_from CanCan::AccessDenied do |exception|
    delete_stored_location
    redirect_to current_user.account, alert: MESSAGE_UNAUTHORIZED
  end

  rescue_from EntitlementException do |exception|
    delete_stored_location
    redirect_to after_sign_in_path_for(current_user), alert: exception.message
  end

  class << self
    def check_entitlements(privilege, **options)
      before_action(options) do |controller|
        controller.send :check_entitlements, privilege
      end
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end

  def entitled_to?(privilege)
    return true if current_user.admin?
    current_entitlements.entitled_to? privilege
  end

  def current_entitlements
    @current_entitlements ||= Entitlements.new(current_user.account)
  end

  def check_entitlements(privilege)
    current_entitlements.validate! privilege
  end

  def storable_location?
    request.fullpath != root_path &&
    request.get? &&
    is_navigational_format? &&
    !devise_controller? &&
    !request.xhr?
  end

  def store_requested_location
    session[:return_to] = request.fullpath
  end

  def delete_stored_location
    session.delete :return_to
  end

  def after_sign_in_path_for(user)
    stored_location = session.delete(:return_to) and return stored_location
    if account = user.account
      account_path account
    else
      accounts_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
