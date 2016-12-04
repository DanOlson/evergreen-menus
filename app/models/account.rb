class Account < ActiveRecord::Base
  validates :name, presence: true
  validates :active, inclusion: { in: [true, false] }
  has_many :users
  has_many :establishments
end