require 'spec_helper'

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
  end
end
