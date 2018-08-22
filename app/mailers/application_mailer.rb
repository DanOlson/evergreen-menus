class ApplicationMailer < ActionMailer::Base
  ADMIN_EMAIL_ADDR = 'admin@evergreenmenus.com'
  DO_NOT_REPLY_EMAIL_ADDR = 'do-not-reply@evergreenmenus.com'

  default from: ADMIN_EMAIL_ADDR
  helper_method :fingerprinted_asset
  helper_method :logo_url
  layout 'mailer'

  def fingerprinted_asset(name)
    Rails.env.production? ? "#{name}-#{ASSET_FINGERPRINT}" : name
  end

  def logo_url
    "#{root_url}images/evergreen-logo-white.png"
  end
end

