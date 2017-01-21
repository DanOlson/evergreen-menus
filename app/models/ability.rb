class Ability
  include CanCan::Ability

  ABILITY_MAP = {
    Role::ADMIN => :admin_abilities,
    Role::STAFF => :staff_abilities
  }

  def initialize(user)
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    abilities = ABILITY_MAP.fetch(user.role.name) { return }
    send abilities, user
  end

  private

  def staff_abilities(user)
    can :manage, Establishment, account_id: user.account_id
    can :show, Account, id: user.account_id
  end

  def admin_abilities(user)
    staff_abilities user

    can :manage, Account, id: user.account_id
  end
end
