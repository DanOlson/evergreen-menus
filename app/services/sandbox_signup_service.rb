class SandboxSignupService
  class EmailTakenError < StandardError; end
  attr_accessor :email
  attr_reader :user

  def initialize(email)
    @email = email
  end

  def call
    raise EmailTakenError if email_taken?
    signup_service.call
    return unless signup_service.success?
    registration_form = create_registration_form signup_service.signup_invitation
    @user = registration_form.model
    account = registration_form.account
    AccountScaffoldingService.call account
  end

  private

  def email_taken?
    User.where(email: email).exists?
  end

  def signup_service
    @signup_service ||= SignupService.new({
      plan_id: Plan.tier_1.id, # TODO: make a dedicated plan
      email: email,
      quantity: 3
    })
  end

  def create_registration_form(invitation)
    registration_form = UserRegistrationForm.from_invitation invitation
    password = SecureRandom.uuid
    registration_form.password = password
    registration_form.password_confirmation = password
    registration_form.save
    registration_form
  end
end
