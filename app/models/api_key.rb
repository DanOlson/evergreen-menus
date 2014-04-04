class ApiKey < ActiveRecord::Base
  belongs_to :user

  validates :access_token, uniqueness: true
  validates :user_id,
            :access_token,
            :expires_at,
            presence: true
end
