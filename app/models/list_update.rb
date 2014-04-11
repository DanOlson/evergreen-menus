class ListUpdate < ActiveRecord::Base
  belongs_to :establishment

  validates :establishment_id, presence: true
  validates :status, presence: true, length: { maximum: 50 }
end
