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

  def google_my_business_enabled?
    AuthToken.google.for_account(self).exists?
  end

  def facebook_enabled?
    AuthToken.facebook_user.for_account(self).exists?
  end
end
