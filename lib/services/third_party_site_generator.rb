require 'erb'
require 'fileutils'

class ThirdPartySiteGenerator
  class << self
    def call(establishment:, list_html:)
      new(establishment: establishment, list_html: list_html).call
    end
  end

  def initialize(establishment:, list_html:)
    @establishment = establishment
    @list_html = list_html
  end

  def call
    public_dir = Rails.env.test? ? 'public-test' : 'public'
    third_party_site_base_path = Rails.root.join 'third-party-site'

    FileUtils.mkdir_p third_party_site_base_path.join public_dir

    template_filepath = third_party_site_base_path.join 'index.html.erb'
    output_filepath   = third_party_site_base_path.join public_dir, 'index.html'
    template          = ERB.new File.open(template_filepath).read

    File.open(output_filepath, 'w+') do |f|
      f << template.result(binding)
    end
  end
end
