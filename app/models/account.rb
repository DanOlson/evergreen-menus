class Account < ActiveRecord::Base
  validates :name, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :google_my_business_account_id, uniqueness: true, allow_nil: true
  has_many :users
  has_many :establishments
  has_many :user_invitations
  has_many :payments
  has_one :subscription
  has_one :plan, through: :subscription
  accepts_nested_attributes_for :establishments

  enum trial_strategy: {
    without_credit_card: 0,
    with_credit_card: 1
  }

  class << self
    def current_trial_strategy
      :without_credit_card
    end
  end

  def google_my_business_enabled?
    AuthToken.google.for_account(self).exists?
  end

  def facebook_enabled?
    AuthToken.facebook_user.for_account(self).exists?
  end
end
