class Role < ActiveRecord::Base
  has_many :users

  SUPER_ADMIN = 'super admin'
  ADMIN = 'admin'
  STAFF = 'staff'

  class << self
    def super_admin
      @super_admin ||= find_by name: SUPER_ADMIN
    end

    def account_admin
      @account_admin ||= find_by name: ADMIN
    end

    def staff
      @staff ||= find_by name: STAFF
    end

    def manager
      STDERR.puts <<-WARN
        [DEPRECATION WARNING] manager role has been renamed
        #{caller.take(3).join("\n")}
      WARN
      account_admin
    end
  end
end
