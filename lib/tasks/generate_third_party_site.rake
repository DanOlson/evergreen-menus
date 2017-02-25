desc "generate the third-party-site/public/index.html file"
task generate_third_party_site: :environment do
  require 'erb'
  require 'fileutils'

  @establishment = Establishment.first || abort("NO ESTABLISHMENTS!")
  @beermapper_host = Rails.env.test? ? 'http://test.beermapper-api.dev' : 'http://beermapper-api.dev'
  public_dir = Rails.env.test? ? 'public-test' : 'public'
  third_party_site_base_path = Rails.root.join 'third-party-site'
  FileUtils.mkdir_p third_party_site_base_path.join public_dir
  template_filepath = third_party_site_base_path.join 'index.html.erb'
  output_filepath = third_party_site_base_path.join public_dir, 'index.html'
  template = ERB.new File.open(template_filepath).read

  File.open(output_filepath, 'w+') do |f|
    f << template.result(binding)
  end
end
