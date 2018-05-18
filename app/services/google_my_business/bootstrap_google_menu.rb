module GoogleMyBusiness
  class BootstrapGoogleMenu
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
        price_list.sections.each_with_index do |section, idx|
          list = establishment.lists.create!({
            name: section.name
          })
          section.items.each_with_index do |item, idx|
            list.beers.create!({
              name: item.name,
              description: item.description,
              price: item.price,
              position: idx
            })
          end

          menu.google_menu_lists.create!({
            list: list,
            position: idx,
            show_price_on_menu: true,
            show_description_on_menu: true
          })
        end
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
