class AccountCancellationService
  class << self
    def call(opts)
      new(opts).call
    end
  end

  def initialize(ability:, account_id:)
    @ability = ability
    @account_id = account_id
  end

  def call
    return unless @ability.can?(:cancel, account)

    account.update active: false
    stripe_id = account.stripe_id or return
    customer = StripeCustomer.find stripe_id
    customer.subscriptions.map &:cancel
  end

  private

  def account
    @account ||= Account.find @account_id
  end
end
