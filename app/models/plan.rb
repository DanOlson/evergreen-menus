class Plan < ActiveRecord::Base
  enum status: { inactive: 0, active: 1 }
  enum interval: { day: 0, week: 1, month: 2, year: 3 }

  monetize :price_cents

  has_many :subscriptions

  class << self
    def tier_1
      active.find_by remote_id: "carryout-#{Rails.env}"
    end

    def tier_2
      active.find_by remote_id: "specialty-#{Rails.env}"
    end

    def tier_3
      active.find_by remote_id: "banquet-#{Rails.env}"
    end
  end
end
