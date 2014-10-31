module V1
  class ScraperSerializer < AppSerializer
    attributes :id,
               :establishment_id,
               :scraper_class_name,
               :last_ran_at,
               :scheduled_run_time
  end
end
