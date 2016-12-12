require 'spec_helper'

feature 'searching for beers', :vcr, :js do
  scenario 'and finding them' do
    load Rails.root.join 'db', 'seeds.rb'
    Establishment.all.each do |e|
      e.geocode
      e.save!
    end
    Scraper.all.each do |s|
      Interactions::Scraper.new(s).scrape!
    end
    visit '/'
    fill_in 'search-field', with: 'surly'
    click_button 'Search'

    ###
    # Have to `trigger` this one, since it's mostly hidden
    # behind the Macs Industrial marker
    find('div[title="Ginger\ Hop"]').trigger('click')
    within('.map-marker') do
      expect(page).to have_link 'Ginger Hop'
      expect(page).to have_css 'li', text: 'Surly Furious'
    end

    find('div[title="Macs\ Industrial"]').click
    within('.map-marker') do
      expect(page).to have_link 'Macs Industrial'
      expect(page).to have_css 'li', text: 'Surly Four'
      expect(page).to have_css 'li', text: 'Surly Hell'
    end
    
    find('div[title="Muddy\ Waters"]').click
    within('.map-marker') do
      expect(page).to have_link 'Muddy Waters'
      expect(page).to have_css 'li', text: 'Surly Bender'
    end

    find('div[title="Groveland\ Tap"]').click
    within('.map-marker') do
      expect(page).to have_link 'Groveland Tap'
      expect(page).to have_css 'li', text: 'Surly Abrasive'
      expect(page).to have_css 'li', text: 'Surly Furious'
      expect(page).to have_css 'li', text: 'Surly Damien'
    end
    
    find('div[title="Edina\ Grill"]').click
    within('.map-marker') do
      expect(page).to have_link 'Edina Grill'
      expect(page).to have_css 'li', text: 'Surly Hell – Brooklyn Center / Lager / 4.5%'
      expect(page).to have_css 'li', text: 'Surly Furious – Brooklyn Center / IPA / 6.6%'
    end
  end
end
