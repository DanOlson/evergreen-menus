class AccountDecorator < ApplicationDecorator
  delegate_all

  attr_reader :google_my_business_service, :facebook_service

  def initialize(account,
                 google_my_business_service: nil,
                 facebook_service: nil)
    super(account)
    @google_my_business_service = google_my_business_service || default_gmb_service
    @facebook_service = facebook_service || default_fb_service
  end

  def google_my_business_accounts
    @google_my_business_accounts ||= google_my_business_service.accounts
  end

  def google_my_business_locations
    @google_my_business_locations ||= google_my_business_service.locations
  end

  def facebook_pages
    @facebook_pages ||= facebook_service.pages
  end

  private

  def default_gmb_service
    GoogleMyBusiness::Service.new account: object
  end

  def default_fb_service
    Facebook::Service.new account: object
  end
end
