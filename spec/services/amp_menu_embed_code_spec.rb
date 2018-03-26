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

  let(:instance) do
    AmpMenuEmbedCode.new(web_menu, {
      base_url: 'test.evergreenmenus.com',
      # json_ld_url: "https://test.evergreenmenus.com/web_menus/#{web_menu.id}/json_ld.js"
    })
  end

  describe '#generate' do
    it 'creates the expected code' do
      expected = <<~HTML.strip
        <div class="evergreen-menu" itemscope itemtype="http://schema.org/Menu">
          <div class="evergreen-menu-list" data-test="list" itemprop="hasMenuSection" itemscope itemtype="http://schema.org/MenuSection">
            <h3 class="evergreen-menu-title" data-test="list-title" itemprop="name">Dinner</h3>
            <amp-list src="https://test.evergreenmenus.com/amp/lists/#{dinner.id}.json" layout="responsive" width="3" height="2">
              <template type="amp-mustache">
                <div class="evergreen-menu-item" itemprop="hasMenuItem" itemscope itemtype="http://schema.org/MenuItem">
                  <span class="evergreen-menu-item-name" data-test="list-item-name" itemprop="name">{{name}}</span>
                  <span itemprop="offers" itemscope itemtype="http://schema.org/Offer">
                    <meta itemprop="priceCurrency" content="USD" />
                    &nbsp;&mdash;&nbsp;
                    <span class="evergreen-menu-item-price" data-test="list-item-price" itemprop="price" content="{{price}}">{{price}}</span>
                  </span>
                  <div class="evergreen-menu-item-description" data-test="list-item-description" itemprop="description">{{description}}</div>
                </div>
              </template>
            </amp-list>
          </div>
          <div class="evergreen-menu-list" data-test="list" itemprop="hasMenuSection" itemscope itemtype="http://schema.org/MenuSection">
            <h3 class="evergreen-menu-title" data-test="list-title" itemprop="name">Coming Soon</h3>
            <amp-list src="https://test.evergreenmenus.com/amp/lists/#{coming_soon.id}.json" layout="responsive" width="3" height="2">
              <template type="amp-mustache">
                <div class="evergreen-menu-item" itemprop="hasMenuItem" itemscope itemtype="http://schema.org/MenuItem">
                  <span class="evergreen-menu-item-name" data-test="list-item-name" itemprop="name">{{name}}</span>
                </div>
              </template>
            </amp-list>
          </div>
        </div>
      HTML

      expect(instance.generate).to eq expected
    end
  end

  describe '#generate_head' do
    it 'creates the expected code' do
      expected = <<~HTML.strip
        <script async custom-element="amp-list" src="https://cdn.ampproject.org/v0/amp-list-0.1.js"></script>
        <script async custom-template="amp-mustache" src="https://cdn.ampproject.org/v0/amp-mustache-0.1.js"></script>
      HTML

      expect(instance.generate_head).to eq expected
    end
  end
end
