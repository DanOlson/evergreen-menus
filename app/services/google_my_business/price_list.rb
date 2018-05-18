require 'forwardable'

module GoogleMyBusiness
  class PriceList
    attr_reader :data

    def initialize(data)
      @data = data || {}
      @label = Label.new data
    end

    def name
      @label.name || 'Menu'
    end

    def sections
      Array(data['sections']).map { |s| Section.new s }
    end

    class Section
      extend Forwardable
      def_delegator :@label, :name

      def initialize(data)
        @data = data
        @label = Label.new data
      end

      def items
        Array(@data['items']).map { |i| Item.new i }
      end

      class Item
        extend Forwardable
        def_delegators :@label, :name, :description

        def initialize(data)
          @data = data
          @label = Label.new data
        end

        def price
          item_price = @data['price']
          dollars = item_price['units']
          if nanos = item_price['nanos']
            cents = String(nanos)[0..1]
            "#{dollars}.#{cents}"
          else
            dollars
          end
        end
      end
    end

    class Label
      def initialize(data)
        @data = data || {}
      end

      def name
        @data.dig('labels', 0, 'displayName')
      end

      def description
        @data.dig('labels', 0, 'description')
      end
    end
  end
end
