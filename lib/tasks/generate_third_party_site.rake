desc "generate the third-party-site/public/index.html file"
task generate_third_party_site: :environment do
  require Rails.root.join 'lib/services/third_party_site_generator'
  include Rails.application.routes.url_helpers

  menu = WebMenu.first
  if !menu
    puts "Couldn't generate third-party site: no web menus exist!"
    exit(1)
  end
  establishment = menu.establishment
  menu = establishment.web_menus.first
  host = Rails.env.test? ? 'http://test.beermapper-api.locl' : 'http://beermapper-api.locl'
  embed_code = MenuEmbedCode.new({
    web_menu: menu,
    menu_url: web_menu_url(menu.id, host: host)
  }).generate

  ThirdPartySiteGenerator.call({
    establishment: establishment,
    list_snippets: [embed_code]
  })
end
