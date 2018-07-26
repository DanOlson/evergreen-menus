class SignupInvitation < ActiveRecord::Base
  belongs_to :account
  belongs_to :accepting_user,
             foreign_key: :accepting_user_id,
             class_name: 'User'
  belongs_to :role

  attr_accessor :first_name, :last_name
  alias_attribute :username, :email
end
