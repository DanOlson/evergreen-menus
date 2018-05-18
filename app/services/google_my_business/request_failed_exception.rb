module GoogleMyBusiness
  class RequestFailedException < StandardError
    attr_reader :response, :parsed_response

    def initialize(response)
      @parsed_response = JSON.parse response.body
      @response = response
      super @parsed_response['error']['message']
    end
  end
end
