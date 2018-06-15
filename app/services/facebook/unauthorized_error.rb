module Facebook
  class UnauthorizedError < StandardError
    class << self
      def for_page(page_id)
        new "No valid Facebook page token for page_id: #{page_id}"
      end

      def for_user(account)
        new "No valid Facebook user token for account with id: #{account.id}"
      end
    end
  end
end
