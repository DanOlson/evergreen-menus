class GoogleMenuList < ActiveRecord::Base
  belongs_to :google_menus
  belongs_to :lists

  validates :position, presence: true, numericality: true
end
