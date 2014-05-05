module ListManagement
  class BeerListUpdater
    class << self
      def update!(establishment, scraper, opts={}, &blk)
        new(establishment, scraper).update! force: !!opts[:force], &blk
      end
    end

    attr_reader :scraper, :list, :establishment

    def initialize(establishment, scraper)
      @establishment = establishment
      @scraper       = scraper
    end

    def update!(force: false, &blk)
      @list = scraper.list
      if !force && there_might_be_a_problem?
        yield Status.failure('list size unacceptable') if block_given?
        return
      end
      delete_old_beers
      create_new_beers
      yield Status.success if block_given?
    rescue => e # Typically 404s from scraper.list
      yield Status.failure(e.message) if block_given?
    end

    # eliminate names we currently have
    def new_beer_names
      list.reject { |name| current_beer_names.include? name }
    end

    # current names that are NOT in @list
    def old_beer_names
      current_beer_names.select { |name| !list.include? name}
    end

    private

    def delete_old_beers
      establishment.beers.delete Beer.where(name: old_beer_names)
    end

    def create_new_beers
      new_beer_names.each do |name|
        establishment.beers << Beer.where(name: name).first_or_create
      end
    end

    def current_beer_names
      @current_beer_names ||= establishment.beers.pluck :name
    end

    def there_might_be_a_problem?
      list.empty? || list_is_less_than_80_percent_of_current?
    end

    def list_is_less_than_80_percent_of_current?
      current_beer_names.size * 0.8 > list.size
    end
  end
end
