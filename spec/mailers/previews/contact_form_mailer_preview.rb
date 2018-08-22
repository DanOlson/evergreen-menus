class ContactFormMailerPreview < ActionMailer::Preview
  def contact_form_email
    ContactFormMailer.contact_form_email({
      name: 'Bobby',
      email: 'bobby@example.com',
      message: 'Hey there, I like your site!'
    })
  end
end
