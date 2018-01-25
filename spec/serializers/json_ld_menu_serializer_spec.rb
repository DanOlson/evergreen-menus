require 'spec_helper'

describe JsonLdMenuSerializer do
  describe '#call' do
    let(:menu) { create :web_menu, :with_lists }
    let(:instance) do
      JsonLdMenuSerializer.new({
        menu: menu,
        url: 'http://farbarmpls.com/menu/'
      })
    end
    let(:parsed_result) { JSON.parse instance.call }

    it 'includes static, menu-level metadata' do
      expect(parsed_result['@context']).to eq 'http://schema.org'
      expect(parsed_result['@type']).to eq 'Menu'
      expect(parsed_result['inLanguage']).to eq 'English'
    end

    it 'includes "url", using the given value' do
      expect(parsed_result['url']).to eq 'http://farbarmpls.com/menu/'
    end

    it 'includes "mainEntityOfPage", using the given url value' do
      expect(parsed_result['mainEntityOfPage']).to eq 'http://farbarmpls.com/menu/'
    end

    it 'excludes offers for menus with unrestricted availability' do
      expect(parsed_result).to_not have_key 'offers'
    end

    it 'represents each list as a "hasMenuSection"' do
      expect(parsed_result['hasMenuSection'].size).to eq menu.lists.size
    end

    it 'represents each menu section with the correct type' do
      menu_section_types = parsed_result['hasMenuSection'].map { |ms| ms['@type'] }
      expect(menu_section_types).to all eq 'MenuSection'
    end

    it 'uses lists[n].name to populate hasMenuSection[n].name' do
      list_names = menu.lists.map &:name
      menu_section_names = parsed_result['hasMenuSection'].map { |ms| ms['name'] }
      expect(menu_section_names).to match_array list_names
    end

    it 'represents menu items within each list using the correct type' do
      parsed_result['hasMenuSection'].each do |menu_section|
        menu_item_types = menu_section['hasMenuItem'].map { |i| i['@type'] }
        expect(menu_item_types).to all eq 'MenuItem'
      end
    end

    it 'identifies each list item by name' do
      parsed_result['hasMenuSection'].each do |menu_section|
        list = menu.lists.find { |l| l.name == menu_section['name'] }
        menu_item_names = menu_section['hasMenuItem'].map { |i| i['name'] }

        expect(menu_item_names).to match_array list.beers.map(&:name)
      end
    end

    it "represents each list items's description" do
      parsed_result['hasMenuSection'].each do |menu_section|
        list = menu.lists.find { |l| l.name == menu_section['name'] }
        item_descriptions = menu_section['hasMenuItem'].map { |i| i['description'] }

        expect(item_descriptions).to match_array list.beers.map(&:description)
      end
    end

    it "represents each list items's price" do
      parsed_result['hasMenuSection'].each do |menu_section|
        list = menu.lists.find { |l| l.name == menu_section['name'] }
        item_offers = menu_section['hasMenuItem'].map { |i| i['offers'] }

        expect(item_offers).to all satisfy { |o| o['@type'] == 'Offer' }
        expect(item_offers).to all satisfy { |o| o['priceCurrency'] == 'USD' }

        list.beers.each do |item|
          menu_items = menu_section['hasMenuItem'].select do |i|
            i['name'] == item.name && i['description'] == item.description
          end
          expect(menu_items).to_not be_empty
          expect(menu_items).to include satisfy { |i| i['offers']['price'] == item.price }
        end
      end
    end

    context 'when the menu has restricted availability' do
      let(:menu) do
        create :web_menu, :with_lists, {
          availability_start_time: '07:30 am',
          availability_end_time: '12:00 pm'
        }
      end

      it 'represents availability as an offer' do
        expected = {
          '@type' => 'Offer',
          'availabilityStarts' => 'T07:30',
          'availabilityEnds' => 'T12:00'
        }
        expect(parsed_result['offers']).to eq expected
      end
    end
  end
end
