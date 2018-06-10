module Facebook
  class UnauthorizedError < StandardError
    def initialize(account)
      super "No valid Facebook user token for account with id: #{account.id}"
    end
  end
end
