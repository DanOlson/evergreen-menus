class InvitationMailer < ApplicationMailer
  def invitation_email(user_invitation)
    @invitation = user_invitation
    @inviter = [
      user_invitation.inviting_user.first_name,
      user_invitation.inviting_user.last_name
    ].join(' ')
    gid = user_invitation.to_sgid(for: 'registration')
    @registration_url = new_invited_registration_url(gid)

    make_bootstrap_mail({
      to: user_invitation.email,
      subject: "Invitation to Evergreen Menus",
      from: DO_NOT_REPLY_EMAIL_ADDR
    })
  end
end
