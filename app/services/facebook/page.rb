module Facebook
  class Page
    FIELDS = %i(id name access_token fan_count)

    class << self
      def fields
        FIELDS
      end
    end

    attr_reader *FIELDS

    def initialize(args = {})
      @id = args['id']
      @name = args['name']
      @access_token = args['access_token']
      @fan_count = args['fan_count']
    end

    def as_json(*)
      {
        'id' => id,
        'name' => name,
        'fan_count' => fan_count
      }
    end
  end
end
