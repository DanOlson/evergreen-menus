require 'spec_helper'

describe 'web_menus/show' do
  let(:web_menu) do
    menu = create :web_menu
    list = create :list, name: 'Burgers', establishment: menu.establishment
    list.beers << Beer.new(name: 'A', position: 2)
    list.beers << Beer.new(name: 'B', position: 0)
    list.beers << Beer.new(name: 'C', position: 1)
    menu.web_menu_lists.create({
        position: 0,
        show_price_on_menu: false,
        show_description_on_menu: false,
        list: list
    })
    menu
  end

  before do
    assign(:web_menu, web_menu)
    render
  end

  it 'orders menu items by position' do
    menu = Capybara::Node::Simple.new rendered
    menu_item_nodes = menu.all '[data-test="list-item-name"]'
    menu_items = menu_item_nodes.map { |i| i.text.strip }
    expect(menu_items).to eq %w(B C A)
  end
end
