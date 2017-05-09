class MenuList < ActiveRecord::Base
  belongs_to :menu
  belongs_to :list
end
