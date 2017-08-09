class DigitalDisplayMenuList < ActiveRecord::Base
  belongs_to :digital_display_menu
  belongs_to :list

  validates :position, presence: true, numericality: true
end
