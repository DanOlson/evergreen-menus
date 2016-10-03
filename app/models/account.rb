class Account < ActiveRecord::Base
  validates :name, :active, presence: true
end
