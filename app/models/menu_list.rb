class MenuList < ActiveRecord::Base
  belongs_to :menu
  belongs_to :list

  validates :position, presence: true, numericality: true
end
