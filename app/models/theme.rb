class Theme
  class << self
    def all
      @all ||= begin
        [
          new({
            name: 'Standard',
            font: 'Architects Daughter',
            background_color: '#FFF',
            text_color: '#040000',
            list_title_color: '#d40a0a'
          }),
          new({
            name: 'Dark',
            font: 'Walter Turncoat',
            background_color: '#242424',
            text_color: '#CCC',
            list_title_color: '#CCC'
          }),
          new({
            name: 'Ireland',
            font: 'Artifika',
            background_color: '#293b2a',
            text_color: '#bbbbbb',
            list_title_color: '#bbbbbb'
          }),
          new({
            name: 'Lounge',
            font: 'Patrick Hand',
            background_color: '#242424',
            text_color: '#755C5C',
            list_title_color: '#711f1f'
          }),
          new({
            name: 'Hollywood',
            font: 'Federo',
            background_color: '#FFF',
            text_color: '#040000',
            list_title_color: '#040000'
          }),
          new({
            name: 'Gamer',
            font: 'Bangers',
            background_color: '#3fa4e8',
            text_color: '#080000',
            list_title_color: '#420798'
          }),
          new({
            name: 'Metalworks',
            font: 'Orbitron',
            background_color: '#cbc9a7',
            text_color: '#292622',
            list_title_color: '#5a4104'
          }),
          new({
            name: 'Granola',
            font: 'Special Elite',
            background_color: '#ab9c75',
            text_color: '#194e33',
            list_title_color: '#074624'
          }),
          new({
            name: 'Medieval',
            font: 'IM Fell English SC',
            background_color: '#e4e4e4',
            text_color: '#040000',
            list_title_color: '#d40a0a'
          }),
          new({
            name: 'Custom',
            font: nil,
            background_color: nil,
            text_color: nil,
            list_title_color: nil
          })
        ]
      end
    end

    def find_by_name(name)
      all.find { |t| t.name == name }
    end
  end

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
