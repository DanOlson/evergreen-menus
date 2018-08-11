class EntitlementException < StandardError
  def initialize(message = 'Not entitled')
    super
  end
end
