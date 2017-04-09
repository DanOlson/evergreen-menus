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

  scenario 'can display multiple menus' do
    expect(establishment_form).to be_displayed

    taps_snippet    = establishment_form.get_snippet_for 'Taps'
    bottles_snippet = establishment_form.get_snippet_for 'Bottles'

    ThirdPartySiteGenerator.call({
      establishment: establishment,
      list_snippets: [taps_snippet, bottles_snippet]
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
