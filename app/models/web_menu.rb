class WebMenu < ActiveRecord::Base
  has_many :web_menu_lists, -> { order('web_menu_lists.position') }, dependent: :destroy
  has_many :lists, -> {
    select(<<-EOF
      lists.*,
      web_menu_lists.position as position,
      web_menu_lists.show_price_on_menu as show_price_on_menu,
      web_menu_lists.show_description_on_menu as show_description_on_menu,
      web_menu_lists.list_item_metadata as list_item_metadata
    EOF
    )
  },
  through: :web_menu_lists
  belongs_to :establishment

  accepts_nested_attributes_for :web_menu_lists, allow_destroy: true

  validates :name, :establishment, presence: true

  def restricted_availability?
    !!availability_start_time
  end
end
