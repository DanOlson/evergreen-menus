task migrate_roles: :environment do
  Role.where(name: Role::SUPER_ADMIN).first_or_create!
  super_admin_id = Role.super_admin.id
  account_admin_id = Role.account_admin.id
  manager_id = Role.find_by(name: 'manager').id

  User.where(role_id: account_admin_id).update_all(role_id: super_admin_id)
  User.where(role_id: manager_id).update_all(role_id: account_admin_id)

  UserInvitation.where(role_id: manager_id).update_all(role_id: account_admin_id)
  SignupInvitation.where(role_id: manager_id).update_all(role_id: account_admin_id)
end
