class Entitlements
  VALID_SUBSCRIPTION_STATUSES = ['active', 'pending_initial_payment'].freeze
  EXCEPTIONS_BY_PRIVILEGE = {
    new_establishment: NewEstablishmentEntitlementException,
    online_menu: OnlineMenuEntitlementException
  }.freeze

  delegate :subscription, to: :account

  attr_reader :account

  def initialize(account)
    @account = account
  end

  def entitled_to?(privilege)
    predicate = "#{privilege}_allowed?"
    respond_to?(predicate) && send(predicate)
  end

  def validate!(privilege)
    raise exception_for(privilege) unless entitled_to?(privilege)
  end

  def new_establishment_allowed?
    valid_subscription? && account.establishments.count < subscription.quantity
  end

  def google_my_business_allowed?
    valid_subscription? && plan_includes_google_my_business?
  end

  def facebook_allowed?
    valid_subscription? && plan_includes_facebook?
  end

  def online_menu_allowed?
    valid_subscription? && plan_includes_online_menu?
  end

  private

  def plan_includes_google_my_business?
    web_integration_plans.include? subscription.plan
  end

  def plan_includes_facebook?
    web_integration_plans.include? subscription.plan
  end

  def plan_includes_online_menu?
    web_integration_plans.include? subscription.plan
  end

  def web_integration_plans
    @web_integration_plans ||= [Plan.tier_2, Plan.tier_3]
  end

  def valid_subscription?
    VALID_SUBSCRIPTION_STATUSES.include? subscription.status
  end

  def exception_for(privilege)
    EXCEPTIONS_BY_PRIVILEGE.fetch(privilege) { EntitlementException }
  end
end
