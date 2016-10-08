class Account < ActiveRecord::Base
  validates :name, :active, presence: true
  has_many :users
  has_many :establishments
end
