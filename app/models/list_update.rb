class ListUpdate < ActiveRecord::Base
  belongs_to :establishment

  validates :establishment_id, presence: true
  validates :status, presence: true, length: { maximum: 50 }

  class << self
    def most_recent
      earliest = Time.zone.now - 1.day
      where(arel_table[:created_at].gteq(earliest))
    end
  end
end
