class Role < ActiveRecord::Base
  has_many :users

  ADMIN = 'admin'
  STAFF = 'staff'
  MANAGER = 'manager'

  class << self
    def admin
      find_by name: ADMIN
    end

    def manager
      find_by name: MANAGER
    end

    def staff
      find_by name: STAFF
    end
  end
end
