class WebMenuList < ActiveRecord::Base
  belongs_to :web_menu
  belongs_to :list

  validates :position, presence: true, numericality: true
end
