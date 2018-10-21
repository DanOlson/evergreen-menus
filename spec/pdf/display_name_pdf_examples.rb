shared_examples 'PDF display name' do
  before do
    list = menu.lists.first
    menu_list = list.menu_lists.find_by menu: menu
    menu_list.display_name = 'A Custom Name'
    menu_list.save
  end

  it 'list name can be customized' do
    expect(reader.pages.first.text.downcase).to include 'a custom name'
  end
end
