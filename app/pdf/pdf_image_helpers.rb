require 'open-uri'

module PdfImageHelpers
  def self.included(base)
    ###
    # Routing helpers must be included on a class, not mixed
    # in via module
    base.send :include, Rails.application.routes.url_helpers
  end

  def establishment_logo(menu)
    if menu.show_logo?
      logo_url = url_for menu.establishment.logo
      image open(logo_url), position: :center, height: 120
    end
  end
end
