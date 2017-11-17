require 'cgi'

class MenuEmbedCode
  TEMPLATE = <<~HTML.strip
    <div class="beermapper-wrapper">
      <div class="beermapper" id="beermapper-menu-%<menu_id>s">
      </div>
      <script
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
