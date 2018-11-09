# Preview all emails at http://localhost:3000/rails/mailers/welcome
class WelcomePreview < ActionMailer::Preview
  def welcome_email
    WelcomeMailer.welcome_email 'test@new-customer.com'
  end

  def trial_will_end_email
    WelcomeMailer.trial_will_end_email(
      recipient: 'test@new-customer.com',
      trial_end_time: Time.now + 3.days
    )
  end
end
