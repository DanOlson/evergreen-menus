class AuthToken < ActiveRecord::Base
  validates :provider, :account, :token_data, presence: true

  belongs_to :account
  belongs_to :establishment

  module Providers
    GOOGLE = 'google'
    FACEBOOK = 'facebook'
  end

  class << self
    def google
      where(provider: Providers::GOOGLE)
    end

    def facebook
      where(provider: Providers::FACEBOOK)
    end

    def for_account(account)
      where(account: account)
    end

    def for_establishment(establishment)
      where(establishment: establishment, account: establishment.account)
    end
  end

  def expired?
    Time.now > expires_at
  end
end
