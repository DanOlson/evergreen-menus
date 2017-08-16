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
end
