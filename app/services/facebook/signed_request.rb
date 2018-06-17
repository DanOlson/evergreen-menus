module Facebook
  class SignedRequest
    attr_reader :signed_request

    def initialize(signed_request)
      @signed_request = signed_request
    end

    def parse
      encoded_signature, payload = signed_request.split '.'
      signature = Base64.urlsafe_decode64(encoded_signature).unpack("H*").first

      hmac = OpenSSL::HMAC.hexdigest(digest, app_secret, payload)
      if hmac == signature
        JSON.parse Base64.urlsafe_decode64 payload
      end
    rescue => e
      Rails.logger.warn "Bad signed request caused error #{e.message}"
      nil
    end

    private

    def app_secret
      ENV.fetch('FACEBOOK_CLIENT_SECRET') do
        APP_CONFIG[:facebook][:client_secret]
      end
    end

    def digest
      OpenSSL::Digest::SHA256.new
    end
  end
end
