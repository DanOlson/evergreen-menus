class ContactFormMailer < ApplicationMailer
  def contact_form_email(form_data)
    @name = form_data[:name]
    @email = form_data[:email]
    @message = form_data[:message]
    mail({
      to: ADMIN_EMAIL_ADDR,
      from: DO_NOT_REPLY_EMAIL_ADDR,
      subject: '[Evergreen Menus] New Contact Form Submission'
    })
  end
end
