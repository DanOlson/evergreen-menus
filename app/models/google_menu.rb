class GoogleMenu < ActiveRecord::Base
  has_many :google_menu_lists, -> { order('google_menu_lists.position') }, dependent: :destroy
  has_many :lists, -> {
      select(<<-EOF
        lists.*,
        google_menu_lists.position as position,
        google_menu_lists.show_price_on_menu as show_price_on_menu,
        google_menu_lists.show_description_on_menu as show_description_on_menu
      EOF
      )
    },
    through: :google_menu_lists
  belongs_to :establishment

  accepts_nested_attributes_for :google_menu_lists, allow_destroy: true
  validates :establishment, presence: true
end
