class UserRegistrationForm
  include ActiveModel::Model

  ATTRIBUTES = %i(
    first_name
    last_name
    email
    username
    password
    password_confirmation
    account
    account_id
    role
    role_id
    invitation
    invitation_id
    invitation_type
  )

  attr_accessor *ATTRIBUTES

  validates :first_name,
            :last_name,
            :email,
            :username,
            :password,
            :password_confirmation,
            :account,
            presence: true

  class << self
    def from_invitation(invitation)
      new({
        first_name: invitation.first_name,
        last_name: invitation.last_name,
        email: invitation.email,
        account: invitation.account,
        role: invitation.role,
        invitation: invitation,
        invitation_id: invitation.id,
        invitation_type: invitation.class.name
      })
    end
  end

  def initialize(attributes)
    ATTRIBUTES.each do |attr|
      send "#{attr}=", attributes[attr]
    end
  end

  def save
    ActiveRecord::Base.transaction do
      model.save
      invitation.accepting_user = model
      invitation.accepted = true
      invitation.save
    end
  end

  def account
    @account ||= Account.find_by(id: account_id) if account_id
  end

  def account_id
    @account_id ||= invitation && invitation.account_id
  end

  def role
    @role ||= role_id ? Role.find_by(id: role_id) : Role.staff
  end

  def role_id
    @role_id ||= invitation && invitation.role_id
  end

  def username
    @username ||= email
  end

  def invitation
    @invitation ||= begin
      if %w(UserInvitation SignupInvitation).include? @invitation_type
        @invitation_type.constantize.find_by(id: invitation_id)
      end
    end
  end

  def model
    @model ||= to_model
  end

  def to_model
    User.new({
      first_name: first_name,
      last_name: last_name,
      username: username,
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      account: account,
      role: role
    }).tap do |user|
      if invitation
        user.establishment_ids = invitation.establishment_ids
      end
    end
  end
end
