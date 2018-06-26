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
        @logger.info "Bootstrapping OnlineMenu for locationId #{@gmb_location_id}"
        location = gmb_service.location @gmb_location_id
      rescue RequestFailedException => e
        @logger.error "Google My Business Location request failed with status: #{e.response.code}"
        @logger.error e.message
        return
      end
      price_list = location.price_list
      ActiveRecord::Base.transaction do
        old_menu = establishment.online_menu
        menu = OnlineMenu.create!(name: price_list.name, establishment: establishment)
        ###
        # According to Rails docs, this is supposed to be deleted
        # automatically by calling establishment.online_menu = menu
        # It's not, however, in Rails 5.0.0.1 in development. It _is_
        # deleted in test environment though... Thus the manual steps.
        # Maybe re-evaluate this if you've upgraded Rails.
        old_menu.destroy if old_menu
        establishment.online_menu = menu
        seed = { lists: [], online_menu_lists: [] }
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

          online_menu_list = menu.online_menu_lists.new({
            list: list,
            position: idx,
            show_price_on_menu: true,
            show_description_on_menu: true
          })

          acc[:online_menu_lists] << online_menu_list
          acc
        end

        List.import data[:lists], recursive: true
        OnlineMenuList.import data[:online_menu_lists]
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
