class RoleSeeder
  class << self
    def call
      Role.where(name: Role::ADMIN).first_or_create!
      Role.where(name: Role::MANAGER).first_or_create!
      Role.where(name: Role::STAFF).first_or_create!
    end
  end
end
