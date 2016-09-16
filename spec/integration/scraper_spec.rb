require 'spec_helper'

describe "updating an establishment's list" do
  before(:all) do
    Establishment.skip_callback(:create, :after, :geocode)
  end

  after(:all) do
    Establishment.set_callback(:create, :after, :geocode)
  end

  let!(:establishment) do
    Establishment.create!({
      name: 'Bar1',
      address: '123 Main',
      url: 'http://beermapper.com/foobar'
    })
  end
  let!(:scraper_model) do
    Scraper.create!({
      establishment: establishment,
      scraper_class_name: 'TestScraper'
    })
  end

  context "when the scraper's url will 404" do
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
end
