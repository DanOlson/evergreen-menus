class WelcomeMailer < ApplicationMailer
  def welcome_email(email_address)
    attachments.inline['create-list.jpg'] = File.read(Rails.root.join('public', 'images', 'create-list.jpg'))
    make_bootstrap_mail({
      to: email_address,
      subject: 'Welcome to Evergreen Menus!'
    })
  end

  def trial_will_end_email(email_address)
    make_bootstrap_mail({
      to: email_address,
      subject: 'Your Evergreen Menus trial is coming to an end',
      bcc: [DAN, TAM]
    })
  end
end
