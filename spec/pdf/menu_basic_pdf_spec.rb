require 'spec_helper'
require 'pdf/list_item_ordering_pdf_examples'

describe MenuBasicPdf do
  let(:menu) { create :menu, :with_lists, list_count: 5, name: 'Test Menu' }

  subject(:reader) do
    instance = MenuBasicPdf.new(menu: menu)
    io = StringIO.new(instance.render)
    PDF::Reader.new io
  end

  describe 'rendered content' do
    it 'has the menu title on the first page' do
      page = reader.pages.first
      expect(page.text).to include 'Test Menu'
    end

    it 'includes all of the lists from the Menu' do
      pdf_text = reader.pages.map(&:text).join(' ')
      menu.lists.each do |list|
        expect(pdf_text).to include list.name
      end
    end

    context 'when the lists have descriptions' do
      let(:description) do
        'All our 100% black angus burgers are hand-pattied and served on a freshly baked brioche bun'
      end
      let(:list) { menu.lists.first }

      before do
        list.update(description: description)
      end

      context 'and the description should be shown' do
        it 'renders the description on the document' do
          page = reader.pages.first
          expect(page.text).to include description
        end
      end

      context 'and the description should be hidden' do
        before do
          menu_list = menu.menu_lists.find_by!(list: list)
          menu_list.update(show_description_on_menu: false)
        end

        it 'does not render the description on the document' do
          page = reader.pages.first
          expect(page.text).to_not include description
        end
      end
    end
  end

  it_behaves_like 'list item ordering'
end
