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
    user_invitation
    user_invitation_id
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
        user_invitation_id: invitation.id
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
      user_invitation.accepting_user = model
      user_invitation.accepted = true
      user_invitation.save
    end
  end

  def account
    @account ||= Account.find_by(id: account_id) if account_id
  end

  def account_id
    @account_id ||= user_invitation && user_invitation.account_id
  end

  def role
    @role ||= role_id ? Role.find_by(id: role_id) : Role.staff
  end

  def role_id
    @role_id ||= user_invitation && user_invitation.role_id
  end

  def username
    @username ||= email
  end

  def user_invitation
    @user_invitation ||= UserInvitation.find_by(id: user_invitation_id)
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
      if user_invitation
        user.establishment_ids = user_invitation.establishment_ids
      end
    end
  end
end
