class Status
  class << self
    def success
      new :success
    end

    def failure(reason)
      new :failure, reason
    end
  end

  STATUSES = [:failure, :success]

  # Define predicates
  STATUSES.each do |st|
    define_method "#{st}?" do
      status == st
    end
  end

  attr_reader :reason, :status

  def initialize(status, reason=nil)
    @status = status
    @reason = reason
  end

  def on_success
    yield if success?
  end

  def on_failure
    yield reason if failure?
  end
end
