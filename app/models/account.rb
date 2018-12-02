class Account < ActiveRecord::Base
  validates :name, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :google_my_business_account_id, uniqueness: true, allow_nil: true
  has_many :users, dependent: :destroy
  has_many :establishments, dependent: :destroy
  has_many :user_invitations, dependent: :destroy
  has_many :signup_invitations, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_one :subscription, dependent: :destroy
  has_one :plan, through: :subscription
  accepts_nested_attributes_for :establishments

  def google_my_business_enabled?
    AuthToken.google.for_account(self).exists?
  end

  def facebook_enabled?
    AuthToken.facebook_user.for_account(self).exists?
  end
end
