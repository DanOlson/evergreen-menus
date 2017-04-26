class Ability
  include CanCan::Ability

  ABILITY_MAP = {
    Role::ADMIN   => :admin_abilities,
    Role::MANAGER => :manager_abilities,
    Role::STAFF   => :staff_abilities
  }

  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  def initialize(user)
    abilities = ABILITY_MAP.fetch(user.role.name) { return }
    send abilities, user
  end

  private

  def staff_abilities(user)
    can :manage, List, establishment_id: user.establishment_ids
    can :read,   Establishment, establishment_staff_assignments: { user_id: user.id }
    can :create, Establishment, establishment_staff_assignments: { user_id: user.id }
    can :update, Establishment, establishment_staff_assignments: { user_id: user.id }
    can :show,   Account, id: user.account_id

    cannot :view_snippet, List
  end

  def manager_abilities(user)
    staff_abilities user

    can :view_snippet, List
    can :manage, Establishment, account_id: user.account_id
    can :manage, List, establishment_id: user.account.establishment_ids
    can :manage, Account, id: user.account_id
    can :manage, User, account_id: user.account_id
    can :manage, UserInvitation, account_id: user.account_id
    can :read, Role, id: [Role.manager.id, Role.staff.id]
  end

  def admin_abilities(user)
    can :manage, :all
  end
end
