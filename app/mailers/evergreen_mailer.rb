class EvergreenMailer < ApplicationMailer
  def new_sandbox_signup_email(signed_up_email)
    @email = signed_up_email

    make_bootstrap_mail(
      to: [DAN, TAM],
      subject: '[Evergreen Menus] New Sandbox Signup'
    )
  end
end
