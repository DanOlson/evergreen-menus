class NewEstablishmentEntitlementException < EntitlementException
  def initialize
    super 'Your subscription does not allow new establishments at this time.'
  end
end
