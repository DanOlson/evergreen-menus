class UserInvitation < ActiveRecord::Base
  belongs_to :account
  belongs_to :inviting_user,
              foreign_key: :inviting_user_id,
              class_name: 'User'
  belongs_to :accepting_user,
             foreign_key: :accepting_user_id,
             class_name: 'User'

  has_many :invitation_establishment_assignments
  has_many :establishments, through: :invitation_establishment_assignments
end
