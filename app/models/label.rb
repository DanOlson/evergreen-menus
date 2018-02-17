class Label
  ICONS_BY_NAME = {
    'Gluten Free' => 'noun_979958_cc',
    'Vegan' => 'noun_990478_cc',
    'Vegetarian' => 'noun_40436_cc',
    'Spicy' => 'noun_707489_cc',
    'Dairy Free' => 'noun_990484_cc',
    'House Special' => 'noun_1266172_cc'
  }

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

  def icon
    ICONS_BY_NAME[name]
  end

  def as_json(*)
    super().tap do |hsh|
      hsh.merge!('icon' => icon) if icon
    end
  end
end
