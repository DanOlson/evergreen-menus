class Menu < ActiveRecord::Base
  has_many :menu_lists, -> { order('menu_lists.position') }, dependent: :destroy
  has_many :lists, through: :menu_lists
  belongs_to :establishment

  accepts_nested_attributes_for :menu_lists, allow_destroy: true

  module Fonts
    TIMES     = 'Times-Roman'
    HELVETICA = 'Helvetica'
    COURIER   = 'Courier'
  end

  FONTS = [
    Fonts::TIMES,
    Fonts::HELVETICA,
    Fonts::COURIER
  ]

  DEFAULT_FONT_SIZE = 10

  validates :font, inclusion: { in: FONTS }
  validates :font_size, numericality: true

  def add_list(list, position: nil)
    position ||= (menu_lists.maximum(:position) || 0)

    menu_lists.create!({
      position: position,
      list: list
    })
  end

  def font
    self[:font] || Fonts::HELVETICA
  end

  def font_size
    self[:font_size] || DEFAULT_FONT_SIZE
  end
end
