require 'forwardable'

module Interactions
  class Scraper < BaseInteractor
    extend Forwardable
    def_delegators :@scraper, :establishment, :scraper_class_name

    attr_reader :scraper

    def initialize(scraper)
      @scraper = scraper
    end

    def scrape!(opts={})
      ListManagement::BeerListUpdater.update!(establishment, scraper_instance, opts) do |status|
        status.on_success do
          list_update.status = 'Success'
        end

        status.on_failure do |reason|
          list_update.status = 'Failed'
          list_update.notes  = reason
        end
        list_update.raw_data = list_as_json
        list_update.save
      end
      set_last_run_time
    end

    def list_update
      @list_update ||= ListUpdate.new establishment: establishment
    end

    private

    def set_last_run_time
      scraper.update_attribute :last_ran_at, Time.zone.now
    end

    def list_as_json
      list.to_json
    end

    def list
      scraper_instance.list
    end

    def scraper_instance
      @scraper_instance ||= scraper_class.new
    end

    def scraper_class
      scraper_class_name.safe_constantize
    end
  end
end
