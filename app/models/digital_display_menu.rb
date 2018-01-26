class DigitalDisplayMenu < ActiveRecord::Base
  DEFAULT_THEME = 'Standard'

  ###
  # This probably goes away if/when we begin to represent themes in the database
  class ThemeType < ActiveModel::Type::Value
    def cast(value)
      Theme.find_by_name(value) || Theme.find_by_name(DEFAULT_THEME)
    end

    def serialize(value)
      value.name
    end
  end

  attribute :theme, ThemeType.new

  has_many :digital_display_menu_lists, -> { order('digital_display_menu_lists.position') }, dependent: :destroy
  has_many :lists, -> {
    select(<<-EOF
      lists.*,
      digital_display_menu_lists.position as position,
      digital_display_menu_lists.show_price_on_menu as show_price_on_menu
    EOF
    )
  },
  through: :digital_display_menu_lists
  belongs_to :establishment

  accepts_nested_attributes_for :digital_display_menu_lists, allow_destroy: true
  alias_attribute :rotation_interval, :rotate_interval_milliseconds
  alias_attribute :background_color, :background_hex_color
  alias_attribute :text_color, :text_hex_color
  alias_attribute :list_title_color, :list_title_hex_color

  ROTATION_INTERVALS = [
    { value: 5000, name: '5 seconds' },
    { value: 10000, name: '10 seconds' },
    { value: 15000, name: '15 seconds' },
    { value: 30000, name: '30 seconds' },
    { value: 60000, name: '1 minute' },
    { value: 120000, name: '2 minutes' },
    { value: 300000, name: '5 minutes' },
    { value: 600000, name: '10 minutes' }
  ]

  def background_color
    self[:background_hex_color] || theme.background_color
  end

  def text_color
    self[:text_hex_color] || theme.text_color
  end

  def list_title_color
    self[:list_title_hex_color] || theme.list_title_color
  end

  def font
    self[:font] || theme.font
  end

  def rotation_interval
    self[:rotate_interval_milliseconds] || ROTATION_INTERVALS.first[:value]
  end
end
