class ApiKey < ActiveRecord::Base
  belongs_to :user

  validates :access_token, uniqueness: true
  validates :user_id,
            :access_token,
            :expires_at,
            presence: true

  class << self
    def active
      where arel_table[:expires_at].gt(Time.zone.now)
    end
  end
end
