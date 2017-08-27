class ApplicationMailer < ActionMailer::Base
  ADMIN_EMAIL_ADDR = 'admin@beermapper.com'
  DO_NOT_REPLY_EMAIL_ADDR = 'do-not-reply@beermapper.com'

  default from: ADMIN_EMAIL_ADDR
  layout 'mailer'
end

