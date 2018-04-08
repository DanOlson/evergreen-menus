class AuthToken < ActiveRecord::Base
  validates :provider, :account, :token_data, presence: true

  belongs_to :account

  module Providers
    GOOGLE = 'google'
  end

  class << self
    def google
      where(provider: Providers::GOOGLE)
    end

    def for_account(account)
      where(account: account)
    end
  end
end
