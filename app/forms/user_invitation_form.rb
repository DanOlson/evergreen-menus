class UserInvitationForm
  include ActiveModel::Model

  ATTRIBUTES = %i(
    first_name
    last_name
    email
    account
    inviting_user
    invite_another
  )

  attr_accessor *ATTRIBUTES

  validates :first_name,
            :last_name,
            :email,
            presence: true

  def initialize(attributes)
    ATTRIBUTES.each do |attr|
      send "#{attr}=", attributes[attr]
    end
  end

  def invite_another?
    invite_another == '1'
  end

  def invite
    to_model.save
  end

  def to_model
    UserInvitation.new({
      first_name: first_name,
      last_name: last_name,
      email: email,
      account: account,
      inviting_user: inviting_user
    })
  end
end
