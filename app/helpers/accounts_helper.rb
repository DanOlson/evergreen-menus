module AccountsHelper
  def google_my_business_link(account)
    if !AuthToken.google.for_account(account).exists?
      link_to 'Connect Google My Business',
              oauth_google_authorize_path,
              class: 'btn btn-success',
              data: { test: 'connect-google-button' }
    else
      button_to 'Disconnect Google My Business',
                oauth_google_revoke_path,
                method: :delete,
                class: 'btn btn-danger',
                data: {
                  test: 'disconnect-google-button',
                  confirm: 'Really disconnect your account from Google?'
                }
    end
  end
end
