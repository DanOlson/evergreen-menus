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
    can :manage, Establishment, account_id: user.account_id
    can :show, Account, id: user.account_id
  end

  def manager_abilities(user)
    staff_abilities user

    can :manage, Account, id: user.account_id
    can :manage, User, account_id: user.account_id
    can :manage, UserInvitation, account_id: user.account_id
  end

  def admin_abilities(user)
    can :manage, :all
  end
end
