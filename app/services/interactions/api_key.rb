require File.expand_path '../base_interactor', __FILE__

module Interactions
  class ApiKey < BaseInteractor
    class << self
      def create(args={})
        new.create args
      end
    end

    def create(args={})
      args = {
        access_token: generate_token,
        expires_at: generate_expiry
      }.merge args
      model.create args
    end

    private

    def generate_expiry
      Time.now + 1.hour
    end

    def generate_token
      loop do
        token = SecureRandom.hex
        break token unless model.where(access_token: token).exists?
      end
    end
  end
end
