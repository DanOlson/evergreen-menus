class DigitalDisplayMenu < ActiveRecord::Base
  has_many :digital_display_menu_lists, -> { order('digital_display_menu_lists.position') }, dependent: :destroy
  has_many :lists, -> {
              select(<<-EOF
                lists.*,
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

  def background_color
    self[:background_hex_color] || '#242424'
  end
end
