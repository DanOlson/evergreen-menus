require 'erb'
require 'cgi'

class AmpMenuEmbedCode
  attr_reader :web_menu, :base_url
  include Rails.application.routes.url_helpers

  MENU_TEMPLATE = <<~ERB.strip
    <div class="evergreen-menu" itemscope itemtype="http://schema.org/Menu">
    <% @lists.each do |list| %>
      <div class="evergreen-menu-list" data-test="list" itemprop="hasMenuSection" itemscope itemtype="http://schema.org/MenuSection">
        <h3 class="evergreen-menu-title" data-test="list-title" itemprop="name"><%= list.name %></h3>
        <amp-list src="https://<%= @base_url %>/amp/lists/<%= list.id %>.json" layout="responsive" width="3" height="2">
          <template type="amp-mustache">
            <div class="evergreen-menu-item" itemprop="hasMenuItem" itemscope itemtype="http://schema.org/MenuItem">
              <span class="evergreen-menu-item-name" data-test="list-item-name" itemprop="name">{{name}}</span>
            <% if list.show_price_on_menu? %>
              <span itemprop="offers" itemscope itemtype="http://schema.org/Offer">
                <meta itemprop="priceCurrency" content="USD" />
                &nbsp;&mdash;&nbsp;
                <span class="evergreen-menu-item-price" data-test="list-item-price" itemprop="price" content="{{price}}">{{price}}</span>
              </span>
            <% end %>
            <% if list.show_description_on_menu? %>
              <div class="evergreen-menu-item-description" data-test="list-item-description" itemprop="description">{{description}}</div>
            <% end %>
            </div>
          </template>
        </amp-list>
      </div>
    <% end %>
    </div>
  ERB

  HEAD_TEMPLATE = <<~HTML.strip
    <script async custom-element="amp-list" src="https://cdn.ampproject.org/v0/amp-list-0.1.js"></script>
    <script async custom-template="amp-mustache" src="https://cdn.ampproject.org/v0/amp-mustache-0.1.js"></script>
  HTML

  def initialize(web_menu, base_url: default_base_url)
    @web_menu = web_menu
    @base_url = base_url
    @lists = @web_menu.lists.sort_by &:position
  end

  def generate
    rendered = ERB.new(MENU_TEMPLATE).result(binding)
    # Remove any lines that are empty (or all spaces)
    rendered.split("\n").reject { |line| line.match /\A\s*\z/ }.join("\n")
  end

  def generate_encoded
    CGI.escapeHTML generate
  end

  def generate_head
    HEAD_TEMPLATE
  end

  def generate_head_encoded
    CGI.escapeHTML generate_head
  end

  private

  def default_base_url
    APP_CONFIG.fetch(:web_menu_host)
  end
end
