module AccountsHelper
  def google_my_business_link(account)
    if !account.google_my_business_enabled?
      connect_google_my_business_link
    else
      edit_google_my_business_associations_link(account)
    end
  end

  def facebook_link(account)
    if !account.facebook_enabled?
      connect_facebook_link
    else
      edit_facebook_associations_link(account)
    end
  end

  def connect_google_my_business_link
    link_to 'Connect',
            oauth_google_authorize_path,
            class: 'btn btn-success btn-sm',
            data: { test: 'connect-google-button' }
  end

  def connect_facebook_link
    link_to 'Connect',
            oauth_facebook_authorize_path,
            class: 'btn btn-success btn-sm',
            data: { test: 'connect-facebook-button' }
  end

  def edit_google_my_business_associations_link(account)
    link_to 'Edit',
            new_account_google_my_business_account_association_path(account),
            class: 'btn btn-primary btn-sm',
            data: { test: 'edit-google-link' }
  end

  def edit_facebook_associations_link(account)
    link_to 'Edit',
            new_account_facebook_establishment_association_path(account),
            class: 'btn btn-primary btn-sm',
            data: { test: 'edit-facebook-link' }
  end

  def disconnect_google_my_business_link
    button_to 'Disconnect',
              oauth_google_revoke_path,
              method: :delete,
              class: 'btn btn-evrgn-delete btn-sm',
              data: {
                test: 'disconnect-google-button',
                confirm: 'Really disconnect your account from Google?'
              }
  end

  def disconnect_facebook_link
    button_to 'Disconnect',
              oauth_facebook_revoke_path,
              method: :delete,
              class: 'btn btn-evrgn-delete btn-sm',
              data: {
                test: 'disconnect-facebook-button',
                confirm: 'Really disconnect your account from Facebook?'
              }
  end

  def google_my_business_account_opts(account)
    account.google_my_business_accounts.map do |acct|
      [acct.account_name, acct.name]
    end
  end

  def facebook_page_opts(account)
    account.facebook_pages.map do |page|
      [page.name, page.id]
    end
  end
end
