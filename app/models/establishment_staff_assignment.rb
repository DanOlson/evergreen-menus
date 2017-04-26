class EstablishmentStaffAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :establishment

  validate :shared_account

  def shared_account
    if user.account != establishment.account
      errors.add(:account, 'must be the same for user and establishment')
    end
  end
end
