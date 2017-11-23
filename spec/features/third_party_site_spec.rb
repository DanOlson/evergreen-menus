require 'spec_helper'

feature 'establishment website', :admin, :js do
  let(:user) { create :user, :manager }
  let(:establishment) { create :establishment, account: user.account }
  let(:taps_list) do
    establishment.lists.create! name: 'Taps'
  end
  let(:bottles_list) do
    establishment.lists.create! name: 'Bottles'
  end
  let(:establishment_form) do
    PageObjects::Admin::EstablishmentForm.new
  end

  def create_beers(list)
    5.times do
      list.beers.create!({
        name: Faker::Beer.name.strip,
        price: '6.5',
        description: Faker::Beer.style
      })
    end
  end

  before do
    create_beers taps_list
    create_beers bottles_list

    login user
    establishment_form.load({
      account_id: user.account_id,
      establishment_id: establishment.id
    })
  end

  scenario 'displaying a menu with multiple lists' do
    expect(establishment_form).to be_displayed

    establishment_form.add_web_menu
    menu_form = PageObjects::Admin::WebMenuForm.new
    expect(menu_form).to be_displayed
    menu_form.name = 'Beer Menu'
    menu_form.select_list 'Taps'
    menu_form.select_list 'Bottles'
    menu_form.submit
    menu_form.cancel

    embed_code = establishment_form.get_snippet_for 'Beer Menu'

    ThirdPartySiteGenerator.call({
      establishment: establishment,
      list_snippets: [embed_code]
    })

    website = PageObjects::ThirdPartySite::Menu.new
    website.load

    expect(website).to have_list_named 'Taps'
    expect(website).to have_list_named 'Bottles'

    site_taps_list    = website.list_named 'Taps'
    site_bottles_list = website.list_named 'Bottles'

    tap_names = site_taps_list.menu_items.map { |i| i.name.text }
    expect(tap_names).to match_array taps_list.beers.map &:name

    bottle_names = site_bottles_list.menu_items.map { |i| i.name.text }
    expect(bottle_names).to match_array bottles_list.beers.map &:name
  end

  scenario 'displaying multiple menus' do
    expect(establishment_form).to be_displayed

    establishment_form.add_web_menu
    tap_menu_form = PageObjects::Admin::WebMenuForm.new
    expect(tap_menu_form).to be_displayed
    tap_menu_form.name = 'Taps Menu'
    tap_menu_form.select_list 'Taps'
    tap_menu_form.submit
    tap_menu_form.cancel

    establishment_form.add_web_menu
    bottle_menu_form = PageObjects::Admin::WebMenuForm.new
    expect(bottle_menu_form).to be_displayed
    bottle_menu_form.name = 'Bottles Menu'
    bottle_menu_form.select_list 'Bottles'
    bottle_menu_form.submit
    bottle_menu_form.cancel

    embed_code_taps = establishment_form.get_snippet_for 'Taps Menu'
    embed_code_bottles = establishment_form.get_snippet_for 'Bottles Menu'

    ThirdPartySiteGenerator.call({
      establishment: establishment,
      list_snippets: [embed_code_taps, embed_code_bottles]
    })

    website = PageObjects::ThirdPartySite::Menu.new
    website.load

    expect(website).to have_list_named 'Taps'
    expect(website).to have_list_named 'Bottles'

    site_taps_list    = website.list_named 'Taps'
    site_bottles_list = website.list_named 'Bottles'

    tap_names = site_taps_list.menu_items.map { |i| i.name.text }
    expect(tap_names).to match_array taps_list.beers.map &:name

    bottle_names = site_bottles_list.menu_items.map { |i| i.name.text }
    expect(bottle_names).to match_array bottles_list.beers.map &:name
  end
end
