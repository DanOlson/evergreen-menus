class MenuList < ActiveRecord::Base
  belongs_to :menu
  belongs_to :list

  validates :position, presence: true, numericality: true

  def display_name=(name)
    list_item_metadata['display_name'] = name
  end
end
