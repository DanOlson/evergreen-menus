# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview
  def invitation_email
    invitation = UserInvitation.new({
      id: '42',
      first_name: 'Donny',
      last_name: 'Kerabatsos',
      email: 'donny@lebowski.me',
      inviting_user: User.new(first_name: 'Jackie', last_name: 'Treehorn'),
      account: Account.new(name: 'The Lanes')
    })
    InvitationMailer.invitation_email invitation
  end
end
