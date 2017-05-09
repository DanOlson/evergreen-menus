class Menu < ActiveRecord::Base
  has_many :menu_lists, -> { order('menu_lists.position') }, dependent: :destroy
  has_many :lists, through: :menu_lists
  belongs_to :establishment

  def add_list(list, position: nil)
    position ||= (menu_lists.maximum(:position) || 0)

    menu_lists.create!({
      position: position,
      list: list
    })
  end
end
