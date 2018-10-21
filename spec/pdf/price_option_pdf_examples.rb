shared_examples 'PDF multiple price options' do |**args|
  show_currency = args.fetch(:show_currency, true)
  context 'when some of the menu items have multiple price options' do
    before do
      list = menu.lists.first
      item = list.beers.first
      item.price_options = [
        PriceOption.new(price: 4, unit: 'Cup'),
        PriceOption.new(price: 6.75, unit: 'Bowl')
      ]
      item.save
    end

    it 'includes each price option' do
      expected = show_currency ? '$4 / $6.75' : '4 / 6.75'
      page = reader.pages.first
      expect(page.text).to include expected
    end
  end
end
