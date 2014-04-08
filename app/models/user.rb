class User < ActiveRecord::Base
  has_many :api_keys

  validates :email, uniqueness: true
  validates :username,
            :email,
            :password_digest,
            presence: true

  has_secure_password
end
