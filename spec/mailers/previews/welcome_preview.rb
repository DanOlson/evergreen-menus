# Preview all emails at http://localhost:3000/rails/mailers/welcome
class WelcomePreview < ActionMailer::Preview
  def welcome_email
    WelcomeMailer.welcome_email 'test@new-customer.com'
  end
end
