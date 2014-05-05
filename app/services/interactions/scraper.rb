require 'forwardable'

module Interactions
  class Scraper < BaseInteractor
    extend Forwardable
    def_delegators :@scraper, :establishment, :scraper_class_name

    attr_reader :scraper

    def initialize(scraper)
      @scraper = scraper
    end

    def scrape!
      ListManagement::BeerListUpdater.update!(establishment, scraper_instance) do |status|
        status.on_success do
          list_update.status = 'Success'
        end

        status.on_failure do |reason|
          list_update.status = 'Failed'
          list_update.notes  = reason
        end
        list_update.save
      end
      set_last_run_time
    end

    private

    def set_last_run_time
      scraper.update_attribute :last_run_at, Time.zone.now
    end

    def list_update
      @list_update ||= ListUpdate.new establishment: establishment
    end

    def scraper_instance
      klass = scraper_class_name.safe_constantize
      klass.new
    end
  end
end
