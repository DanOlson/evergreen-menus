class Role < ActiveRecord::Base
  has_many :users

  ADMIN = 'admin'
  STAFF = 'staff'

  class << self
    def admin
      find_by name: ADMIN
    end

    def staff
      find_by name: STAFF
    end
  end
end
