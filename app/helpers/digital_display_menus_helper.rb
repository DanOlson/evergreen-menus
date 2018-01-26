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
    Theme.all.to_json
  end
end
