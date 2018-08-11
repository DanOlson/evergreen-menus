class Entitlements
  VALID_SUBSCRIPTION_STATUSES = ['active', 'pending_initial_payment'].freeze
  EXCEPTIONS_BY_PRIVILEGE = {
    new_establishment: NewEstablishmentEntitlementException
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

  private

  def valid_subscription?
    VALID_SUBSCRIPTION_STATUSES.include? subscription.status
  end

  def exception_for(privilege)
    EXCEPTIONS_BY_PRIVILEGE.fetch(privilege) { EntitlementException }
  end
end
