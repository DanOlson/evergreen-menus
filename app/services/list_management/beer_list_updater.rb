module ListManagement
  class BeerListUpdater
    class << self
      def update_lists!(logger=ListUpdateLogger)
        logger.info "\n\n******* Beginning update *******"
        fetcher = ListManagement::BeerListFetcher.new logger
        fetcher.lists.each do |list|
          hsh = list.to_hash
          establishment = find_or_create_establishment hsh
          list_update = ListUpdate.new({
            raw_data: list.to_json,
            establishment: establishment
          })
          update!(establishment, list) do |status|
            status.on_success do
              list_update.status = 'Success'
              logger.info "#{hsh[:name]} Success!"
            end

            status.on_failure do |reason|
              list_update.status = 'Failed'
              list_update.notes = reason
              logger.warn "#{hsh[:name]} Failed! #{reason}"
            end
            list_update.save
          end
        end
      end

      def update!(establishment, list, opts={}, &blk)
        new(establishment, list).update! force: !!opts[:force], &blk
      end

      private

      # Find or create an establishment by name and address
      # Update url separately to allow for changing scraper urls
      def find_or_create_establishment(args={})
        name    = args.fetch :name
        address = args.fetch :address
        est     = Establishment.where(name: name, address: address).first_or_create
        est.update_attribute :url, args[:url]
        est
      end
    end

    attr_reader :list, :establishment

    def initialize(establishment, list)
      @establishment = establishment
      @list          = list
    end

    def update!(force: false, &blk)
      if !force && there_might_be_a_problem?
        yield Status.failure('list size unacceptable') if block_given?
        return
      end
      delete_old_beers
      create_new_beers
      yield Status.success if block_given?
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

    class Status
      class << self
        def success
          new :success
        end

        def failure(reason)
          new :failure, reason
        end
      end

      STATUSES = [:failure, :success]

      # Define predicates
      STATUSES.each do |st|
        define_method "#{st}?" do
          status == st
        end
      end

      attr_reader :reason, :status

      def initialize(status, reason=nil)
        @status = status
        @reason = reason
      end

      def on_success
        yield if success?
      end

      def on_failure
        yield reason if failure?
      end
    end
  end
end
