class Ability
  include CanCan::Ability

  ABILITY_MAP = {
    Role::SUPER_ADMIN => :super_admin_abilities,
    Role::ADMIN => :account_admin_abilities,
    Role::STAFF => :account_staff_abilities
  }

  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  def initialize(user)
    abilities = ABILITY_MAP.fetch(user.role.name) { return }
    send abilities, user
  end

  private

  def account_staff_abilities(user)
    can :manage, List, establishment_id: user.establishment_ids
    can :manage, Menu, establishment_id: user.establishment_ids
    can :manage, DigitalDisplayMenu, establishment_id: user.establishment_ids
    can :manage, WebMenu, establishment_id: user.establishment_ids
    can :manage, OnlineMenu, establishment_id: user.establishment_ids
    can :read,   Establishment, establishment_staff_assignments: { user_id: user.id }
    can :create, Establishment, establishment_staff_assignments: { user_id: user.id }
    can :update, Establishment, establishment_staff_assignments: { user_id: user.id }
    can :show,   Account, id: user.account_id

    cannot :view_snippet, WebMenu
    cannot :view_web_integrations, Account
  end

  def account_admin_abilities(user)
    account_staff_abilities user

    can :view_snippet, WebMenu
    can :view_web_integrations, Account
    can :manage, Establishment, account_id: user.account_id
    can :manage, List, establishment_id: user.account.establishment_ids
    can :manage, Menu, establishment_id: user.account.establishment_ids
    can :manage, DigitalDisplayMenu, establishment_id: user.account.establishment_ids
    can :manage, WebMenu, establishment_id: user.account.establishment_ids
    can :manage, OnlineMenu, establishment_id: user.account.establishment_ids
    can :update, Account, id: user.account_id
    can :manage, User, account_id: user.account_id
    can :manage, UserInvitation, account_id: user.account_id
    can :read, Role, id: [Role.account_admin.id, Role.staff.id]
    can :manage, :google_my_business
    can :manage, :facebook
    can :cancel, Account, id: user.account_id
  end

  def super_admin_abilities(user)
    can :manage, :all
  end
end
