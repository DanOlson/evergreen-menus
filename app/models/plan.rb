class Plan < ActiveRecord::Base
  TIER_1_REMOTE_ID = "t1-#{Rails.env}".freeze
  TIER_2_REMOTE_ID = "t2-#{Rails.env}".freeze
  TIER_3_REMOTE_ID = "t3-#{Rails.env}".freeze

  enum status: { inactive: 0, active: 1 }
  enum interval: { day: 0, week: 1, month: 2, year: 3 }

  monetize :price_cents

  has_many :subscriptions

  class << self
    def tier_1
      active.find_by remote_id: TIER_1_REMOTE_ID
    end

    def tier_2
      active.find_by remote_id: TIER_2_REMOTE_ID
    end

    def tier_3
      active.find_by remote_id: TIER_3_REMOTE_ID
    end
  end
end
