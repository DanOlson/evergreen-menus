class WelcomeMailer < ApplicationMailer
  def welcome_email(email)
    mail({
      to: email,
      subject: 'Welcome to Evergreen Menus!'
    })
  end
end
