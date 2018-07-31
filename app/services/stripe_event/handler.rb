module StripeEvent
  class Handler
    @@handlers_by_event = {}

    class << self
      def handles(event)
        handlers_by_event[event] = self
      end

      def for(event)
        handlers_by_event[event]
      end

      private

      def handlers_by_event
        @@handlers_by_event
      end
    end

    def initialize(event, logger: default_logger)
      @event = event
      @logger = logger
    end

    def call
      raise NotImplementedError
    end

    private

    def default_logger
      Rails.logger
    end
  end
end
