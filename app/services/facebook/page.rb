module Facebook
  class Page
    attr_reader :id, :name, :access_token

    def initialize(args = {})
      @id = args['id']
      @name = args['name']
      @access_token = args['access_token']
    end
  end
end
