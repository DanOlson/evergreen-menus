module DigitalDisplayMenusHelper
  FONTS = [
    'Abel',
    'Aclonica',
    'Actor',
    'Aldrich',
    'Allerta',
    'Allerta Stencil',
    'Amaranth',
    'Andika',
    'Anonymous Pro',
    'Architects Daughter',
    'Artifika',
    'Bangers',
    'Bubblegum Sans',
    'Cabin Sketch',
    'Comfortaa',
    'Coming Soon',
    'Convergence',
    'Cousine',
    'Cuprum',
    'Days One',
    'Delius',
    'Devonshire',
    'Didact Gothic',
    'Droid Sans',
    'Federo',
    'Geo',
    'Gochi Hand',
    'Gruppo',
    'Hammersmith One',
    'Holtwood One SC',
    'IM Fell English SC',
    'Inconsolata',
    'Istok Web',
    'Josefin Sans',
    'Kenia',
    'Merienda One',
    'Miltonian',
    'Mountains of Christmas',
    'News Cycle',
    'Nova Flat',
    'Open Sans',
    'Orbitron',
    'Over the Rainbow',
    'Patrick Hand',
    'Permanent Marker',
    'Philosopher',
    'Playfair Display',
    'Podkova',
    'Quicksand',
    'Rationale',
    'Rock Salt',
    'Rokkitt',
    'Smokum',
    'Special Elite',
    'Spirax',
    'Syncopate',
    'Walter Turncoat'
  ]

  class Theme
    attr_reader :name, :font, :background_color, :text_color, :list_title_color

    def initialize(name:, font:, background_color:, text_color:, list_title_color:)
      @name             = name
      @font             = font
      @background_color = background_color
      @text_color       = text_color
      @list_title_color = list_title_color
    end

    def as_json(*)
      {
        name: name,
        font: font,
        backgroundColor: background_color,
        textColor: text_color,
        listTitleColor: list_title_color
      }
    end
  end

  THEMES = [
    Theme.new({
      name: 'Standard',
      font: 'Architects Daughter',
      background_color: '#FFF',
      text_color: '#040000',
      list_title_color: '#d40a0a'
    }),
    Theme.new({
      name: 'Dark',
      font: 'Walter Turncoat',
      background_color: '#242424',
      text_color: '#CCC',
      list_title_color: '#CCC'
    }),
    Theme.new({
      name: 'Ireland',
      font: 'Artifika',
      background_color: '#293b2a',
      text_color: '#bbbbbb',
      list_title_color: '#bbbbbb'
    }),
    Theme.new({
      name: 'Lounge',
      font: 'Patrick Hand',
      background_color: '#242424',
      text_color: '#755C5C',
      list_title_color: '#711f1f'
    }),
    Theme.new({
      name: 'Hollywood',
      font: 'Federo',
      background_color: '#FFF',
      text_color: '#040000',
      list_title_color: '#040000'
    }),
    Theme.new({
      name: 'Gamer',
      font: 'Bangers',
      background_color: '#3fa4e8',
      text_color: '#080000',
      list_title_color: '#420798'
    }),
    Theme.new({
      name: 'Metalworks',
      font: 'Orbitron',
      background_color: '#cbc9a7',
      text_color: '#292622',
      list_title_color: '#5a4104'
    }),
    Theme.new({
      name: 'Granola',
      font: 'Special Elite',
      background_color: '#ab9c75',
      text_color: '#194e33',
      list_title_color: '#074624'
    }),
    Theme.new({
      name: 'Medieval',
      font: 'IM Fell English SC',
      background_color: '#e4e4e4',
      text_color: '#040000',
      list_title_color: '#d40a0a'
    }),
    Theme.new({
      name: 'Custom',
      font: nil,
      background_color: nil,
      text_color: nil,
      list_title_color: nil
    })
  ]

  def digital_display_menu_json(digital_display_menu)
    DigitalDisplayMenuSerializer.new(digital_display_menu).call
  end

  def rotation_intervals_json
    DigitalDisplayMenu::ROTATION_INTERVALS.to_json
  end

  def font_options_json
    FONTS.map do |font|
      { name: font, value: font }
    end.to_json
  end

  def theme_options_json
    THEMES.to_json
  end
end
