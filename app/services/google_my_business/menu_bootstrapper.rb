module GoogleMyBusiness
  class MenuBootstrapper
    class << self
      def call(establishment:, gmb_location_id:)
        new(
          establishment: establishment,
          gmb_location_id: gmb_location_id
        ).call
      end
    end

    attr_reader :gmb_service, :establishment

    def initialize(establishment:,
                   gmb_location_id:,
                   gmb_service: nil,
                   logger: default_logger)
      @establishment = establishment
      @gmb_location_id = gmb_location_id
      @gmb_service = gmb_service || default_gmb_service
      @logger = logger
    end

    def call
      begin
        @logger.info "Bootstrapping GoogleMenu for locationId #{@gmb_location_id}"
        location = gmb_service.location @gmb_location_id
      rescue RequestFailedException => e
        @logger.warn "Location request failed with status: #{e.response.code}"
        @logger.warn e.message
        return
      end
      price_list = location.price_list
      ActiveRecord::Base.transaction do
        menu = establishment.create_google_menu!(name: price_list.name)
        seed = { lists: [], google_menu_lists: [] }
        data = price_list.sections.each_with_index.inject(seed) do |acc, (section, idx)|
          list = establishment.lists.where(name: section.name).first
          if !list
            list = List.new({
              establishment: establishment,
              name: section.name,
              beers: section.items.each_with_index.map do |item, idx|
                Beer.new({
                  name: item.name,
                  description: item.description,
                  price: item.price,
                  position: idx
                })
              end
            })

            acc[:lists] << list
          end

          google_menu_list = menu.google_menu_lists.new({
            list: list,
            position: idx,
            show_price_on_menu: true,
            show_description_on_menu: true
          })

          acc[:google_menu_lists] << google_menu_list
          acc
        end

        List.import data[:lists], recursive: true
        GoogleMenuList.import data[:google_menu_lists]
      end
    end

    private

    def default_gmb_service
      Service.new account: establishment.account
    end

    def default_logger
      Rails.logger
    end
  end
end
