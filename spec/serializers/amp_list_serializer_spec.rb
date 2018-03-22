require 'spec_helper'

describe AmpListSerializer do
  let(:instance) { AmpListSerializer.new list }
  let(:list) do
    list = create :list
    list.beers.create!({
      name: 'Flatbread',
      description: 'A decent pizza',
      price: '8.5',
      position: 1
    })
    list.beers.create!({
      name: 'Wings',
      description: 'Dry-rub, bone-in masterpieces',
      price: '10',
      position: 2
    })
    list.beers.create!({
      name: 'Basket of Fries',
      description: 'A delicious basket of french fries',
      price: '5',
      position: 0
    })
    list
  end

  describe '#call' do
    it 'represents all the items' do
      formatted = <<-JSON
{
  "items": [
    {
      "name": "Basket of Fries",
      "description": "A delicious basket of french fries",
      "price": "$5"
    },
    {
      "name": "Flatbread",
      "description": "A decent pizza",
      "price": "$8.50"
    },
    {
      "name": "Wings",
      "description": "Dry-rub, bone-in masterpieces",
      "price": "$10"
    }
  ]
}
      JSON
      expected = JSON.generate(JSON.parse(formatted))

      expect(instance.call).to eq expected
    end
  end
end
