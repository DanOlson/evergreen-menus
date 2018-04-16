class Account < ActiveRecord::Base
  validates :name, presence: true
  validates :active, inclusion: { in: [true, false] }
  has_many :users
  has_many :establishments
  has_many :user_invitations

  def google_my_business_enabled?
    AuthToken.google.for_account(self).exists?
  end
end
