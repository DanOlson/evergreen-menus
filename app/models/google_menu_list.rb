class GoogleMenuList < ActiveRecord::Base
  belongs_to :google_menu
  belongs_to :list

  validates :position, presence: true, numericality: true
end
