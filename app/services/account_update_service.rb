class AccountUpdateService
  class << self
    def call(account:, ability:, **opts)
      new(account: account, ability: ability).call opts
    end
  end

  def initialize(account:,
                 ability:,
                 stripe_customer: StripeCustomer,
                 logger: Rails.logger)
    @account = account
    @ability = ability
    @stripe_customer = stripe_customer
    @logger = logger
    @success = false
  end

  def call(options)
    options.delete(:active) unless @ability.can?(:activate, @account)
    stripe_opts = options.delete :stripe
    update_account options
    update_stripe_customer stripe_opts
    @success = true
  rescue ActiveRecord::RecordInvalid, StripeCustomer::InvalidRequestError => e
    @success = false
  ensure
    return self
  end

  def success?
    !!@success
  end

  def errors
    @account.errors
  end

  def error_messages
    errors.full_messages
  end

  private

  def update_account(options)
    @account.update! options
  end

  def update_stripe_customer(options)
    handle_stripe_error do
      if options.present? && @account.stripe_id
        @stripe_customer.update @account.stripe_id, options
      end
    end
  end

  def handle_stripe_error
    yield
  rescue StripeCustomer::InvalidRequestError => e
    @logger.error %(No Stripe customer found for "#{@account.stripe_id}")
    @account.errors.add :payment, 'info could not be updated'
    raise e
  end
end
