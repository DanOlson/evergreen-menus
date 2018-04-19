require 'spec_helper'

module GoogleMyBusiness
  describe WebMenuSerializer do
    let(:instance) { WebMenuSerializer.new web_menu }
    let(:web_menu) { create :web_menu, name: 'Happy Hour' }
    let(:appetizers) { create :list, name: 'Appetizers', establishment: web_menu.establishment }
    let(:tap_beer) { create :list, name: 'Tap Beer', establishment: web_menu.establishment }
    let!(:wings) { create :menu_item, name: 'Wings', price: '9.50', description: 'Bone-in wings', list: appetizers }
    let!(:pretzel) { create :menu_item, name: 'Pretzel', price: '4.95', description: 'Boring salt-bread', list: appetizers }
    let!(:furious) { create :menu_item, name: 'Surly Furious', price: '6', description: 'American IPA', list: tap_beer }
    let!(:summit) { create :menu_item, name: 'Summit EPA', price: '5', description: 'Extra Pale Ale', list: tap_beer }

    let(:show_price) { true }
    let(:show_description) { true }

    before do
      web_menu.web_menu_lists.create!({
        list: tap_beer,
        position: 1,
        show_price_on_menu: show_price,
        show_description_on_menu: show_description
      })
      web_menu.web_menu_lists.create!({
        list: appetizers,
        position: 0,
        show_price_on_menu: show_price,
        show_description_on_menu: show_description
      })
    end

    describe '#call' do
      context 'when showing both price and description' do
        it 'creates a priceList per Google specifications' do
          expected = <<~JSON
            {
              "priceListId": "Happy Hour",
              "labels": [
                {
                  "displayName": "Happy Hour"
                }
              ],
              "sections": [
                {
                  "sectionId": "appetizers",
                  "labels": [
                    {
                      "displayName": "Appetizers"
                    }
                  ],
                  "items": [
                    {
                      "itemId": "#{wings.id}",
                      "labels": [
                        {
                          "displayName": "Wings",
                          "description": "Bone-in wings"
                        }
                      ],
                      "price": {
                        "currencyCode": "USD",
                        "units": "9",
                        "nanos": "500000000"
                      }
                    },
                    {
                      "itemId": "#{pretzel.id}",
                      "labels": [
                        {
                          "displayName": "Pretzel",
                          "description": "Boring salt-bread"
                        }
                      ],
                      "price": {
                        "currencyCode": "USD",
                        "units": "4",
                        "nanos": "950000000"
                      }
                    }
                  ]
                },
                {
                  "sectionId": "tap_beer",
                  "labels": [
                    {
                      "displayName": "Tap Beer"
                    }
                  ],
                  "items": [
                    {
                      "itemId": "#{furious.id}",
                      "labels": [
                        {
                          "displayName": "Surly Furious",
                          "description": "American IPA"
                        }
                      ],
                      "price": {
                        "currencyCode": "USD",
                        "units": "6",
                        "nanos": "000000000"
                      }
                    },
                    {
                      "itemId": "#{summit.id}",
                      "labels": [
                        {
                          "displayName": "Summit EPA",
                          "description": "Extra Pale Ale"
                        }
                      ],
                      "price": {
                        "currencyCode": "USD",
                        "units": "5",
                        "nanos": "000000000"
                      }
                    }
                  ]
                }
              ]
            }
          JSON

          expect(instance.call).to be_json_eql expected
        end
      end

      context 'when showing price but hiding description' do
        let(:show_price) { true }
        let(:show_description) { false }

        it 'creates a priceList without description' do
          expected = <<~JSON
            {
              "priceListId": "Happy Hour",
              "labels": [
                {
                  "displayName": "Happy Hour"
                }
              ],
              "sections": [
                {
                  "sectionId": "appetizers",
                  "labels": [
                    {
                      "displayName": "Appetizers"
                    }
                  ],
                  "items": [
                    {
                      "itemId": "#{wings.id}",
                      "labels": [
                        {
                          "displayName": "Wings"
                        }
                      ],
                      "price": {
                        "currencyCode": "USD",
                        "units": "9",
                        "nanos": "500000000"
                      }
                    },
                    {
                      "itemId": "#{pretzel.id}",
                      "labels": [
                        {
                          "displayName": "Pretzel"
                        }
                      ],
                      "price": {
                        "currencyCode": "USD",
                        "units": "4",
                        "nanos": "950000000"
                      }
                    }
                  ]
                },
                {
                  "sectionId": "tap_beer",
                  "labels": [
                    {
                      "displayName": "Tap Beer"
                    }
                  ],
                  "items": [
                    {
                      "itemId": "#{furious.id}",
                      "labels": [
                        {
                          "displayName": "Surly Furious"
                        }
                      ],
                      "price": {
                        "currencyCode": "USD",
                        "units": "6",
                        "nanos": "000000000"
                      }
                    },
                    {
                      "itemId": "#{summit.id}",
                      "labels": [
                        {
                          "displayName": "Summit EPA"
                        }
                      ],
                      "price": {
                        "currencyCode": "USD",
                        "units": "5",
                        "nanos": "000000000"
                      }
                    }
                  ]
                }
              ]
            }
          JSON

          expect(instance.call).to be_json_eql expected
        end
      end

      context 'when hiding price but showing description' do
        let(:show_price) { false }
        let(:show_description) { true }

        it 'creates a priceList without prices' do
          expected = <<~JSON
            {
              "priceListId": "Happy Hour",
              "labels": [
                {
                  "displayName": "Happy Hour"
                }
              ],
              "sections": [
                {
                  "sectionId": "appetizers",
                  "labels": [
                    {
                      "displayName": "Appetizers"
                    }
                  ],
                  "items": [
                    {
                      "itemId": "#{wings.id}",
                      "labels": [
                        {
                          "displayName": "Wings",
                          "description": "Bone-in wings"
                        }
                      ]
                    },
                    {
                      "itemId": "#{pretzel.id}",
                      "labels": [
                        {
                          "displayName": "Pretzel",
                          "description": "Boring salt-bread"
                        }
                      ]
                    }
                  ]
                },
                {
                  "sectionId": "tap_beer",
                  "labels": [
                    {
                      "displayName": "Tap Beer"
                    }
                  ],
                  "items": [
                    {
                      "itemId": "#{furious.id}",
                      "labels": [
                        {
                          "displayName": "Surly Furious",
                          "description": "American IPA"
                        }
                      ]
                    },
                    {
                      "itemId": "#{summit.id}",
                      "labels": [
                        {
                          "displayName": "Summit EPA",
                          "description": "Extra Pale Ale"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          JSON

          expect(instance.call).to be_json_eql expected
        end
      end
    end
  end
end
