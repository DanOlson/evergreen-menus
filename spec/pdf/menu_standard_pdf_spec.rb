require 'spec_helper'

describe MenuStandardPdf do
  let(:menu) { create :menu, :with_lists, list_count: 5, name: 'Test Standard Menu' }

  subject(:reader) do
    instance = MenuStandardPdf.new(menu: menu)
    io = StringIO.new(instance.render)
    PDF::Reader.new io
  end

  describe 'rendered content' do
    it 'has the menu title on the first page' do
      page = reader.page(1)
      expect(page.text).to include 'TEST STANDARD MENU'
    end

    it 'includes all of the lists from the Menu' do
      pdf_text = reader.pages.map(&:text).join(' ')
      menu.lists.each do |list|
        expect(pdf_text).to include list.name.upcase
      end
    end
  end

  describe 'rendering dietary restriction icons' do
    let(:item_name) { 'Kung Pao Chicken' }
    let(:labels) { [] }
    let(:menu) do
      menu = create :menu, name: 'Dinner'
      list = create :list, name: 'Entrees', establishment: menu.establishment
      create :menu_item, name: item_name, list: list, labels: labels
      menu.add_list list
      menu
    end

    shared_examples 'menu with icon font' do
      it 'includes the icon font' do
        page = reader.page(1)
        expect(page).to satisfy { |p|
          p.fonts.values.any? { |font|
            String(font[:BaseFont]).end_with?('Glyphter')
          }
        }
      end
    end

    context 'for "Spicy" label' do
      let(:labels) { ['Spicy'] }

      it_behaves_like 'menu with icon font'

      it 'includes the correct icon text' do
        page = reader.page(1)
        post_item_text = page.text.split(item_name).last
        expect(post_item_text).to include "\u0046"
      end
    end

    context 'for "Gluten Free" label' do
      let(:labels) { ['Gluten Free'] }

      it_behaves_like 'menu with icon font'

      it 'includes the correct icon text' do
        page = reader.page(1)
        post_item_text = page.text.split(item_name).last
        expect(post_item_text).to include "\u0044"
      end
    end

    context 'for "Vegan" label' do
      let(:labels) { ['Vegan'] }

      it_behaves_like 'menu with icon font'

      it 'includes the correct icon text' do
        page = reader.page(1)
        post_item_text = page.text.split(item_name).last
        expect(post_item_text).to include "\u0042"
      end
    end

    context 'for "Vegetarian" label' do
      let(:labels) { ['Vegetarian'] }

      it_behaves_like 'menu with icon font'

      it 'includes the correct icon text' do
        page = reader.page(1)
        post_item_text = page.text.split(item_name).last
        expect(post_item_text).to include "\u004b"
      end
    end

    context 'for "Dairy Free" label' do
      let(:labels) { ['Dairy Free'] }

      it_behaves_like 'menu with icon font'

      it 'includes the correct icon text' do
        page = reader.page(1)
        post_item_text = page.text.split(item_name).last
        expect(post_item_text).to include "\u0041"
      end
    end

    context 'for "House Special" label' do
      let(:labels) { ['House Special'] }

      it_behaves_like 'menu with icon font'

      it 'includes the correct icon text' do
        page = reader.page(1)
        post_item_text = page.text.split(item_name).last
        expect(post_item_text).to include "\u004a"
      end
    end

    context 'without labels' do
      let(:labels) { [] }

      it 'does not include the icon font' do
        page = reader.page(1)
        expect(page).to satisfy { |p|
          p.fonts.values.none? { |font|
            String(font[:BaseFont]).end_with?('Glyphter')
          }
        }
      end
    end

    context 'with multiple labels' do
      let(:labels) { ['Vegan', 'Gluten Free', 'Dairy Free'] }

      it_behaves_like 'menu with icon font'

      it 'includes the correct icon text' do
        page = reader.page(1)
        post_item_text = page.text.split(item_name).last
        expect(post_item_text).to include "\u0042 \u0044 \u0041"
      end
    end
  end
end
