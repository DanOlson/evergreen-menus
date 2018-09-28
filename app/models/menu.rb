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

  module Templates
    BASIC    = 'Basic'
    STANDARD = 'Standard'
    CENTERED = 'Centered'
    IMAGE    = 'Image'

    class << self
      def pdf_class_for(template)
        if TEMPLATES.include? template
          const_get "Menu#{template}Pdf"
        else
          MenuBasicPdf
        end
      end
    end
  end

  TEMPLATES = [
    Templates::STANDARD,
    Templates::CENTERED,
    Templates::IMAGE,
    Templates::BASIC
  ]

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

  def template
    self[:template] || TEMPLATES.first
  end

  def restricted_availability?
    !!availability_start_time
  end

  def show_logo?
    establishment.logo.attached? && read_attribute(:show_logo)
  end
end
