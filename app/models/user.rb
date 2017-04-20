class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :api_keys
  belongs_to :account
  belongs_to :role

  validates :email, uniqueness: true
  validates :username,
            :email,
            presence: true

  delegate :active?, to: :account, allow_nil: true

  ###
  # Devise
  def active_for_authentication?
    super && (!account || active?)
  end
end
