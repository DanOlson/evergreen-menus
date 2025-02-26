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

    it 'uses lists[n].description to populate hasMenuSection[n].description' do
      list_descriptions = menu.lists.map &:description
      menu_section_descriptions = parsed_result['hasMenuSection'].map { |ms| ms['description'] }
      expect(menu_section_descriptions).to match_array list_descriptions
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

    context 'when some of the menu items have images attached' do
      before do
        list = menu.lists.first
        item = list.beers.first
        File.open(file_fixture('indeed-logo.png')) do |image_file|
          item.image.attach({
            io: image_file,
            filename: 'indeed-logo.png',
            content_type: 'image/png'
          })
        end
      end

      subject do
        parsed_result['hasMenuSection'][0]['hasMenuItem'][0]['image']
      end

      it { is_expected.to start_with('http://') }
      it { is_expected.to end_with('indeed-logo.png') }
    end

    context 'when some of the menu items have multiple price options' do
      before do
        list = menu.lists.first
        item = list.beers.first
        item.price_options = [
          PriceOption.new(price: 9, unit: 'Glass'),
          PriceOption.new(price: 44, unit: 'Bottle')
        ]
        item.save
      end

      it 'represents each price option as an offer' do
        offers = parsed_result['hasMenuSection'][0]['hasMenuItem'][0]['offers']
        per_glass, per_bottle = offers

        expect(per_glass['@type']).to eq 'Offer'
        expect(per_glass['priceCurrency']).to eq 'USD'
        expect(per_glass['price']).to eq 9.0
        expect(per_glass['description']).to eq 'Glass'

        expect(per_bottle['@type']).to eq 'Offer'
        expect(per_bottle['priceCurrency']).to eq 'USD'
        expect(per_bottle['price']).to eq 44.0
        expect(per_bottle['description']).to eq 'Bottle'
      end
    end

    context 'when the lists have customized display names' do
      let(:menu) { create :web_menu, :with_lists, list_count: 1 }

      before do
        web_menu_list = menu.web_menu_lists.first
        web_menu_list.update(display_name: 'Customized Display Name™')
      end

      it 'uses the custom name as the menu section name' do
        menu_section = parsed_result['hasMenuSection'].first
        expect(menu_section['name']).to eq 'Customized Display Name™'
      end
    end

    describe 'representing dietary restrictions' do
      let(:menu) do
        menu = create :web_menu, name: 'Dinner'
        list = create :list, name: 'Entrees', establishment: menu.establishment
        create :menu_item, name: 'some dish', list: list, labels: [label]
        menu.web_menu_lists.create!(
          position: 0,
          list: list
        )
        menu
      end

      subject do
        parsed_result['hasMenuSection'][0]['hasMenuItem'][0]['suitableForDiet']
      end

      context 'with "Gluten Free" label' do
        let(:label) { 'Gluten Free' }

        it { is_expected.to eq 'http://schema.org/GlutenFreeDiet' }
      end

      context 'with "Vegan" label' do
        let(:label) { 'Vegan' }

        it { is_expected.to eq 'http://schema.org/VeganDiet' }
      end

      context 'with "Vegetarian" label' do
        let(:label) { 'Vegetarian' }

        it { is_expected.to eq 'http://schema.org/VegetarianDiet' }
      end

      context 'with "Dairy Free" label' do
        let(:label) { 'Dairy Free' }

        it { is_expected.to eq 'http://schema.org/LowLactoseDiet' }
      end

      context 'with "Spicy" label' do
        let(:label) { 'Spicy' }

        it { is_expected.to eq nil }
      end

      context 'with "House Special" label' do
        let(:label) { 'House Special' }

        it { is_expected.to eq nil }
      end
    end
  end
end
