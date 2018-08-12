class NewEstablishmentEntitlementException < EntitlementException
  MESSAGE = 'Your subscription does not allow new establishments at this time.'.freeze

  def initialize
    super MESSAGE
  end
end
