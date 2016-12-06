require 'spec_helper'

describe "updating an establishment's list" do
  context "when the scraper's url will 404", :vcr do
    before do
      Establishment.skip_callback(:create, :after, :geocode)
    end

    after do
      Establishment.set_callback(:create, :after, :geocode)
    end

    let(:establishment) do
      Establishment.create!({
        name: 'Bar1',
        address: '123 Main',
        url: 'http://beermapper.com/foobar'
      })
    end
    let(:scraper_model) do
      Scraper.create!({
        establishment: establishment,
        scraper_class_name: 'TestScraper'
      })
    end
    class TestScraper < BeerList::Establishments::Establishment
      def url
        'http://beermapper.com/foobar'
      end

      def get_list
        []
      end
    end

    it 'completes without erroring' do
      expect {
        Interactions::Scraper.new(scraper_model).scrape!
      }.to_not raise_error
    end

    it 'creates a failed ListUpdate' do
      Interactions::Scraper.new(scraper_model).scrape!
      list_update = ListUpdate.last
      expect(list_update.status).to eq 'Failed'
      expect(list_update.notes).to match /404/
    end
  end

  context "successfully", :vcr do
    let(:establishment) do
      Establishment.create!({
        name: 'Edina Grill',
        street_address: '5028 France Ave S',
        city: 'Edina',
        state: 'MN',
        postal_code: '55424',
        url: 'http://www.edinagrill.com/current-tap-list'
      })
    end
    let(:scraper) do
      Scraper.create!({
        establishment: establishment,
        scraper_class_name: 'BeerList::Establishments::EdinaGrill'
      })
    end

    before do
      Interactions::Scraper.new(scraper).scrape!
    end

    it 'creates the list of beers for the establishment' do
      expect(establishment.beers.count).to eq 30
    end

    it 'created a successful ListUpdate' do
      list_update = establishment.list_updates.last
      expect(list_update.status).to eq 'Success'
    end

    it 'a second scrape that finds a reduced menu reduces the beer list accordingly' do
      expect(establishment.beers.count).to eq 30

      Interactions::Scraper.new(scraper).scrape!

      expect(establishment.beers.count).to eq 28
    end
  end
end
