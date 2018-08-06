module StripeEvent
  class Handler
    @@handlers_by_event = {}

    class << self
      def handles(event_type)
        handlers_by_event[event_type] = self
      end

      def for(stripe_event)
        event_type = stripe_event.type
        klass = handlers_by_event.fetch(event_type) { StripeEvent::NullHandler }
        klass.new stripe_event
      end

      private

      def handlers_by_event
        @@handlers_by_event
      end
    end

    attr_reader :event

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
