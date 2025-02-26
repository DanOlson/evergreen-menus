require 'spec_helper'
require 'pdf/dietary_restriction_icon_pdf_examples'
require 'pdf/list_item_ordering_pdf_examples'
require 'pdf/price_option_pdf_examples'
require 'pdf/display_name_pdf_examples'

describe MenuCenteredPdf do
  let(:menu) { create :menu, :with_lists, list_count: 5, name: 'Test Standard Menu' }

  subject(:reader) do
    instance = MenuCenteredPdf.new(menu: menu)
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

  it_behaves_like 'rendering dietary restriction icons'
  it_behaves_like 'list item ordering'
  it_behaves_like 'PDF display name'
  it_behaves_like 'PDF multiple price options', show_currency: false
end
