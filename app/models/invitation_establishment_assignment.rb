class InvitationEstablishmentAssignment < ActiveRecord::Base
  belongs_to :user_invitation
  belongs_to :establishment
end
