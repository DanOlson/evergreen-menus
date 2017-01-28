class InvitationMailer < ApplicationMailer
  def invitation_email(user_invitation)
    @invitation = user_invitation
    @inviter = [
      user_invitation.inviting_user.first_name,
      user_invitation.inviting_user.last_name
    ].join(' ')
    @registration_url = 'beermapper.com/register'

    mail({
      to: user_invitation.email,
      subject: "Your BeerMapper Invitation"
    })
  end
end
