class ApplicationMailer < ActionMailer::Base
  ADMIN_EMAIL_ADDR = 'admin@evergreenmenus.com'
  DO_NOT_REPLY_EMAIL_ADDR = 'do-not-reply@evergreenmenus.com'

  default from: ADMIN_EMAIL_ADDR
  layout 'mailer'
end

