require 'spec_helper'

describe AmpMenuEmbedCode do
  let(:web_menu) do
    create :web_menu
  end
  let(:coming_soon) do
    create :list, :beer, :with_items, item_count: 5, name: 'Coming Soon', establishment: web_menu.establishment
  end
  let(:dinner) do
    create :list, :with_items, name: 'Dinner', establishment: web_menu.establishment
  end

  before do
    web_menu.web_menu_lists.create!(
      list: coming_soon,
      position: 1,
      show_price_on_menu: false,
      show_description_on_menu: false
    )
    web_menu.web_menu_lists.create!(
      list: dinner,
      position: 0,
      show_price_on_menu: true,
      show_description_on_menu: true
    )
  end

  describe '#generate' do
    let(:instance) do
      AmpMenuEmbedCode.new(web_menu, base_url: 'https://test.evergreenmenus.com')
    end

    it 'creates the expected code' do
      expected = <<~HTML.strip
        <div class="evergreen-menu">
          <div class="evergreen-menu-list" data-test="list">
            <h3 class="evergreen-menu-title" data-test="list-title">Dinner</h3>
            <amp-list src="https://test.evergreenmenus.com/amp/lists/#{dinner.id}.json" layout="responsive" width="3" height="2">
              <template type="amp-mustache">
                <div class="evergreen-menu-item">
                  <span class="evergreen-menu-item-name" data-test="list-item-name">{{name}}</span>
                  <span class="evergreen-menu-item-price" data-test="list-item-price">{{price}}</span>
                  <div class="evergreen-menu-item-description" data-test="list-item-description">{{description}}</div>
                </div>
              </template>
            </amp-list>
          </div>
          <div class="evergreen-menu-list" data-test="list">
            <h3 class="evergreen-menu-title" data-test="list-title">Coming Soon</h3>
            <amp-list src="https://test.evergreenmenus.com/amp/lists/#{coming_soon.id}.json" layout="responsive" width="3" height="2">
              <template type="amp-mustache">
                <div class="evergreen-menu-item">
                  <span class="evergreen-menu-item-name" data-test="list-item-name">{{name}}</span>
                </div>
              </template>
            </amp-list>
          </div>
        </div>
      HTML

      expect(instance.generate).to eq expected
    end
  end
end
