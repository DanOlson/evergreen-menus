require 'cgi'

class MenuEmbedCode
  TEMPLATE = <<~HTML.strip
    <div class="evergreen-wrapper">
      <div class="evergreen" id="evergreen-menu-%<menu_id>s">
      </div>
      <script
        async
        type="text/javascript"
        src="%<menu_url>s">
      </script>
    </div>
  HTML

  def initialize(web_menu:, menu_url:)
    @web_menu = web_menu
    @menu_url = menu_url
  end

  def generate
    TEMPLATE % { menu_id: @web_menu.id, menu_url: @menu_url }
  end

  def generate_encoded
    CGI.escapeHTML generate
  end
end
