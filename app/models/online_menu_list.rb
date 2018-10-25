class OnlineMenuList < ActiveRecord::Base
  belongs_to :online_menu
  belongs_to :list

  validates :position, presence: true, numericality: true

  def display_name=(display_name)
    list_item_metadata['display_name'] = display_name
  end
end
