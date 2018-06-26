class OnlineMenuList < ActiveRecord::Base
  belongs_to :online_menu
  belongs_to :list

  validates :position, presence: true, numericality: true
end
