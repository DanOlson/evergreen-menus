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

  def credit_card_info
    return unless object.stripe_id.present?
    customer = StripeCustomer.find(object.stripe_id) or return
    card_info = customer.sources.data[0] or return
    "#{card_info.brand} ending in #{card_info.last4}"
  end

  private

  def default_gmb_service
    GoogleMyBusiness::Service.new account: object
  end

  def default_fb_service
    Facebook::Service.new account: object
  end
end
