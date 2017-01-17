require Rails.root.join 'db/seeds/role_seeder'

namespace :db do
  desc 'seed roles'
  task seed_roles: :environment do
    RoleSeeder.call
  end
end
