require 'cgi'

class ListHtmlSnippet
  TEMPLATE = <<~HTML
    <div class="beermapper-wrapper">
      <div class="beermapper" id="beermapper-menu-%<list_id>s">
      </div>
      <script
        type="text/javascript"
        src="%<menu_url>s">
      </script>
    </div>
  HTML

  def initialize(list:, menu_url:)
    @list     = list
    @menu_url = menu_url
  end

  def generate
    snippet = TEMPLATE % { list_id: @list.id, menu_url: @menu_url }
    snippet.strip
  end

  def generate_encoded
    CGI.escapeHTML generate
  end
end
