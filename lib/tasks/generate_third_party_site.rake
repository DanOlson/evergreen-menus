desc "generate the third-party-site/public/index.html file"
task generate_third_party_site: :environment do
  require Rails.root.join 'lib/services/third_party_site_generator'
  include Rails.application.routes.url_helpers

  establishment = Establishment.first || abort("NO ESTABLISHMENTS!")
  list = establishment.lists.first
  host = Rails.env.test? ? 'http://test.beermapper-api.dev' : 'http://beermapper-api.dev'
  list_html = ListHtmlSnippet.new({
    list: list,
    menu_url: menu_list_url(list, host: host)
  }).generate

  ThirdPartySiteGenerator.call({
    establishment: establishment,
    list_snippets: [list_html]
  })
end
