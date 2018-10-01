class OnlineMenu < ActiveRecord::Base
  has_many :online_menu_lists, -> { order('online_menu_lists.position') }, dependent: :destroy
  has_many :lists, -> {
      select(<<-EOF
        lists.*,
        online_menu_lists.position as position,
        online_menu_lists.show_price_on_menu as show_price_on_menu,
        online_menu_lists.show_description_on_menu as show_description_on_menu,
        online_menu_lists.list_item_metadata as list_item_metadata
      EOF
      )
    },
    through: :online_menu_lists
  belongs_to :establishment

  accepts_nested_attributes_for :online_menu_lists, allow_destroy: true
  validates :establishment, presence: true
end
