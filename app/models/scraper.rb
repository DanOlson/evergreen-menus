class Scraper < ActiveRecord::Base
  belongs_to :establishment
  validates :establishment, :scraper_class_name, presence: true

  class << self
    def queued_for_update
      joins(:establishment).
      merge(Establishment.active).
      where arel_table[:scheduled_run_time].lt(Time.zone.now).and(arel_table[:last_ran_at].lt(23.hours.ago).or(arel_table[:last_ran_at].eq(nil)))
    end
  end

  ###
  # FIXME: Work around this. This is an issue with embedding.
  # Use links hash, maybe?
  def active_model_serializer
    V1::ScraperSerializer
  end
end
