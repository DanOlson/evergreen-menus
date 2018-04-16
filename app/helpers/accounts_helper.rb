module AccountsHelper
  def google_my_business_link(account)
    if !account.google_my_business_enabled?
      link_to 'Connect Google My Business',
              oauth_google_authorize_path,
              class: 'btn btn-success',
              data: { test: 'connect-google-button' }
    else
      button_to 'Disconnect Google My Business',
                oauth_google_revoke_path,
                method: :delete,
                class: 'btn btn-evrgn-delete',
                data: {
                  test: 'disconnect-google-button',
                  confirm: 'Really disconnect your account from Google?'
                }
    end
  end

  def google_my_business_account_opts(account)
    account.google_my_business_accounts.map do |acct|
      [acct.account_name, acct.name]
    end
  end
end
