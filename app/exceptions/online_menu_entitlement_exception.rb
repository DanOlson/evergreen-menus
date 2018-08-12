class OnlineMenuEntitlementException < EntitlementException
  MESSAGE = 'Your subscription does not include web integrations.'.freeze

  def initialize
    super MESSAGE
  end
end
