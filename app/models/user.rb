class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :api_keys
  belongs_to :account

  validates :email, uniqueness: true
  validates :username,
            :email,
            presence: true

  delegate :active?, to: :account, allow_nil: true

  ###
  # This removes the method added by ActiveRecord based on the
  # column name `password_digest`. Ruby will still find Devise's
  # implementation of `password_digest` when called on a User
  # instance. Remove this when the column is removed.
  undef_method :password_digest

  ###
  # Devise
  def active_for_authentication?
    super && active?
  end
end
