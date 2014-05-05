module ListManagement
  class BeerListFetcher
    def initialize(logger=nil)
      @logger = logger || Logger.new(STDOUT)
    end

    def establishments
      @establishments ||= get_establishments
    end

    def lists
      @lists ||= get_lists
    end

    private

    def get_establishments
      BeerList.establishment_instances
    end

    # Calling +list+ on +establishment+ (a BeerList::Establishment)
    # will scrape the url for that establishment. Rescue and log any
    # errors that occur in the process. Typically 404s.
    def get_lists
      establishments.map do |establishment|
        begin
          establishment.list
        rescue => e
          logger.warn "#{establishment.name} Scraper Failed!\n#{e.message}\n#{e.backtrace.join("\n\t")}"
          nil
        end
      end.compact
    end

    def logger
      @logger
    end
  end
end
