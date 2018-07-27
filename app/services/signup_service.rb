class SignupService
  attr_reader :email, :credit_card_token, :plan_id, :signup_invitation

  def initialize(email:, credit_card_token:, plan_id:, logger: default_logger)
    @email = email
    @credit_card_token = credit_card_token
    @plan_id = plan_id
    @logger = logger
    @success = false
  end

  def call
    ActiveRecord::Base.transaction do
      account = create_account
      stripe_customer = create_stripe_customer
      link_customer_to_account account: account, customer: stripe_customer
      create_subscription account: account, customer: stripe_customer
      @signup_invitation = create_invitation account: account
      @success = true
    end
  rescue => e
    @logger.error "Failed to create subscription."
    @logger.error e.message
    @logger.error e.backtrace.join("\n")
  end

  def success?
    @success
  end

  private

  def plan
    @plan ||= Plan.find plan_id
  end

  def create_account
    Account.create! name: "#{email} Account", active: true
  end

  def create_stripe_customer
    StripeCustomer.create email: email, source: credit_card_token
  end

  def link_customer_to_account(account:, customer:)
    account.update! stripe_id: customer.id
  end

  def create_subscription(account:, customer:)
    stripe_subscription = StripeSubscription.create({
      customer: customer,
      plan: plan
    })
    Subscription.create!({
      account: account,
      plan: plan,
      remote_id: stripe_subscription.id,
      payment_method: 'stripe',
      status: :pending_initial_payment
    })
  end

  def create_invitation(account:)
    SignupInvitation.create!({
      account: account,
      role: Role.manager,
      email: email
    })
  end

  def default_logger
    Rails.logger
  end
end
