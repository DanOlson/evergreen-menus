class UserInvitationForm
  include ActiveModel::Model

  ATTRIBUTES = %i(
    first_name
    last_name
    email
    account
    role_id
    establishment_ids
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
    invitation = to_model
    invitation.save
    send_invitation_email invitation
  end

  def to_model
    UserInvitation.new({
      first_name: first_name,
      last_name: last_name,
      email: email,
      role_id: role_id,
      account: account,
      establishment_ids: establishment_ids,
      inviting_user: inviting_user
    })
  end

  def establishment_ids
    @establishment_ids || []
  end

  def model_name
    to_model.model_name
  end

  private

  def send_invitation_email(invitation)
    InvitationMailer.invitation_email(invitation).deliver_now
  end
end
