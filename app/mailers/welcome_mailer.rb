class WelcomeMailer < ApplicationMailer
  def welcome_email(email_address)
    make_bootstrap_mail({
      to: email_address,
      subject: 'Welcome to Evergreen Menus!'
    })
  end
end
