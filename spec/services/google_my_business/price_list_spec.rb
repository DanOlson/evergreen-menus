require 'spec_helper'

module GoogleMyBusiness
  describe PriceList do
    describe '#name' do
      subject { PriceList.new(data).name }

      context 'when initialized with no data' do
        let(:data) { nil }
        it { is_expected.to eq 'Menu' }
      end

      context 'when initialized with data' do
        let(:data) do
          {
            'labels' => [{'displayName' => 'My Menu'}]
          }
        end

        it { is_expected.to eq 'My Menu' }
      end
    end

    describe '#sections' do
      subject(:sections) { PriceList.new(data).sections }

      context 'when initialized with no data' do
        let(:data) { nil }
        it { is_expected.to eq [] }
      end

      context 'when initialized with data' do
        let(:data) do
          {
            'sections' => [
              {
                "sectionId" => "pasta",
                "labels" => [
                  {
                    "displayName" => "Pasta"
                  }
                ],
                "items" => []
              },
              {
                "sectionId" => "entrees",
                "labels" => [
                  {
                    "displayName" => "Entrees"
                  }
                ],
                "items" => []
              }
            ]
          }
        end

        it 'has the right number of sections' do
          expect(sections.size).to eq 2
        end

        it 'is an Array of Section objects' do
          expect(sections).to all be_a PriceList::Section
        end

        it 'creates sections with the correct names' do
          pasta, entrees = sections
          expect(pasta.name).to eq 'Pasta'
          expect(entrees.name).to eq 'Entrees'
        end

        describe 'items' do
          subject(:items) { PriceList.new(data).sections[0].items }

          context 'when initialized with no data' do
            let(:data) do
              {
                'sections' => [
                  {
                    "sectionId" => "pasta",
                    "labels" => [
                      {
                        "displayName" => "Pasta"
                      }
                    ]
                  }
                ]
              }
            end

            it { is_expected.to eq [] }
          end

          context 'when initialized with data' do
            let(:data) do
              {
                'sections' => [
                  {
                    "sectionId" => "pasta",
                    "labels" => [
                      {
                        "displayName" => "Pasta"
                      }
                    ],
                    "items" => [
                      {
                        "itemId" => "11559",
                        "labels" => [
                          {
                            "displayName" => "Chicken Florentine Pasta",
                            "description" => "Pasta with spinach, tomato, artichoke, garlic, red onion, parmesan and mozzarella"
                          }
                        ],
                        "price" => {
                          "currencyCode" => "USD",
                          "units" => "16"
                        }
                      },
                      {
                        "itemId" => "11341",
                        "labels" => [
                          {
                            "displayName" => "Macaroni and Cheese",
                            "description" => "Classic homemade mac and cheese topped with breadcrumbs"
                          }
                        ],
                        "price" => {
                          "currencyCode" => "USD",
                          "units" => "9",
                          "nanos" => 250000000
                        }
                      }
                    ]
                  }
                ]
              }
            end

            it 'has the right number of Items' do
              expect(items.size).to eq 2
            end

            it 'is an Array of Item objects' do
              expect(items).to all be_an PriceList::Section::Item
            end

            it 'represents each Item correctly' do
              florentine, mac_and_cheese = items

              expect(florentine.name).to eq 'Chicken Florentine Pasta'
              expect(florentine.description).to eq 'Pasta with spinach, tomato, artichoke, garlic, red onion, parmesan and mozzarella'
              expect(florentine.price).to eq '16'
              expect(mac_and_cheese.name).to eq 'Macaroni and Cheese'
              expect(mac_and_cheese.description).to eq 'Classic homemade mac and cheese topped with breadcrumbs'
              expect(mac_and_cheese.price).to eq '9.25'
            end
          end
        end
      end
    end
  end
end
