class WebMenuList < ActiveRecord::Base
  belongs_to :web_menu
  belongs_to :list

  validates :position, presence: true, numericality: true

  def display_name=(display_name)
    list_item_metadata['display_name'] = display_name
  end

  def html_classes=(html_classes)
    list_item_metadata['html_classes'] = html_classes
  end
end
