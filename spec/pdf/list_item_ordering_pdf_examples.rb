shared_examples 'list item ordering' do
  let(:menu) do
    menu = create :menu
    list = create :list, name: 'Burgers', establishment: menu.establishment
    list.beers << Beer.new(name: 'A', position: 2)
    list.beers << Beer.new(name: 'B', position: 0)
    list.beers << Beer.new(name: 'C', position: 1)
    menu.menu_lists.create({
        position: 0,
        show_price_on_menu: false,
        list: list
    })
    menu
  end

  it 'orders by position' do
    expected = %w(B C A)
    page = reader.page(1)
    lines = page.text.split(/[[:space:]]+/)
    ordered_menu_items = lines.select { |l| expected.include? l }
    expect(ordered_menu_items).to eq expected
  end
end
