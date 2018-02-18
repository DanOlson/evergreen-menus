class Label
  ICON_DATA_BY_NAME = {
    'Gluten Free' => {
      icon: 'noun_979958_cc',
      glyph: "\u0044"
    },
    'Vegan' => {
      icon: 'noun_990478_cc',
      glyph: "\u0042"
    },
    'Vegetarian' => {
      icon: 'noun_40436_cc',
      glyph: "\u004b"
    },
    'Spicy' => {
      icon: 'noun_707489_cc',
      glyph: "\u0046"
    },
    'Dairy Free' => {
      icon: 'noun_990484_cc',
      glyph: "\u0041"
    },
    'House Special' => {
      icon: 'noun_1266172_cc',
      glyph: "\u004a"
    }
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
    data = ICON_DATA_BY_NAME[name] and data[:icon]
  end

  def glyph
    data = ICON_DATA_BY_NAME[name] and data[:glyph]
  end

  def as_json(*)
    super().tap do |hsh|
      hsh.merge!('icon' => icon) if icon
    end
  end
end
