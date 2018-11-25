# Preview all emails at http://localhost:3000/rails/mailers/evergreen_mailer
class EvergreenMailerPreview < ActionMailer::Preview
  def new_sandbox_signup_email
    EvergreenMailer.new_sandbox_signup_email 'donny@lebowski.me'
  end
end
