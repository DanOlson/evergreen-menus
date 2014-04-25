module Interactions
  class Scraper < BaseInteractor
    delegate :establishment, :scraper_class_name, to: :scraper
    attr_reader :scraper

    def initialize(scraper)
      @scraper = scraper
    end

    def scrape!
      ListManagement::BeerListUpdater.update!(establishment, beer_list) do |status|
        status.on_success do
          list_update.status = 'Success'
        end

        status.on_failure do |reason|
          list_update.status = 'Failed'
          list_update.notes = reason
        end
        list_update.save
      end
    end

    private

    def list_update
      @list_update ||= ListUpdate.new({
        raw_data: beer_list.to_json,
        establishment: establishment
      })
    end

    def beer_list
      scraper_instance.list
    end

    def scraper_instance
      klass = scraper_class_name.safe_constantize
      klass.new
    end
  end
end
