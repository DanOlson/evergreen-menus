require 'erb'

class AmpMenuEmbedCode
  attr_reader :web_menu, :base_url

  MENU_TEMPLATE = <<~ERB.strip
    <div class="evergreen-menu">
    <% @lists.each do |list| %>
      <div class="evergreen-menu-list" data-test="list">
        <h3 class="evergreen-menu-title" data-test="list-title"><%= list.name %></h3>
        <amp-list src="<%= @base_url %>/amp/lists/<%= list.id %>.json" layout="responsive" width="3" height="2">
          <template type="amp-mustache">
            <div class="evergreen-menu-item">
              <span class="evergreen-menu-item-name" data-test="list-item-name">{{name}}</span>
            <% if list.show_price_on_menu? %>
              <span class="evergreen-menu-item-price" data-test="list-item-price">{{price}}</span>
            <% end %>
            <% if list.show_description_on_menu? %>
              <div class="evergreen-menu-item-description" data-test="list-item-description">{{description}}</div>
            <% end %>
            </div>
          </template>
        </amp-list>
      </div>
    <% end %>
    </div>
  ERB

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

  private

  def default_base_url
    APP_CONFIG.fetch(:web_menu_host)
  end
end
