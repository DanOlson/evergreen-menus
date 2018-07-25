class Subscription < ActiveRecord::Base
  belongs_to :account
  belongs_to :plan

  validates :remote_id, presence: true

  enum status: {
    active: 0,
    inactive: 1,
    pending_initial_payment: 2,
    canceled: 3
  }
end
