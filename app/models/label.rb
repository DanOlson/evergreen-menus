class Label
  class << self
    def from(value)
      return value if value.is_a?(Label)
      new(name: value)
    end
  end

  attr_reader :name

  def initialize(name:)
    @name = name
  end
end
