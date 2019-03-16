require_relative '../../authentication_helper'

class WebMenuPreview < SitePrism::Section
  include AuthenticationHelper

  class List < SitePrism::Section
    class ListItem < SitePrism::Section
      element :name_elem, '[data-test="list-item-name"]'
      element :price_elem, '[data-test="list-item-price"]'
      element :description_elem, '[data-test="list-item-description"]'
      element :image_elem, '[data-test="list-item-image"]'

      alias_method :has_price?, :has_price_elem?
      alias_method :has_image?, :has_image_elem?

      def name
        name_elem.text.strip
      end

      def price
        price_elem.text.strip
      end

      def description
        description_elem.text.strip
      end
    end

    element :title_elem, '[data-test="list-title"]'
    element :description_element, '[data-test="list-description"]'
    element :notes_element, '[data-test="list-notes"]'
    sections :items, ListItem, '[data-test="list-item"]'

    alias_method :has_description?, :has_description_element?
    alias_method :has_notes?, :has_notes_element?

    def title
      title_elem.text
    end

    def description
      description_element.text.strip
    end

    def notes
      notes_element.text.strip
    end

    def has_item?(name)
      !!item_named(name)
    end

    def item_named(name)
      items.find { |i| i.name == name }
    end

    def html_classes
      root_element['class']
    end

    def has_html_classes?(candidate)
      html_classes.include? candidate
    end
  end

  element :availability_restriction_el, '[data-test="availability-restriction"]'
  sections :lists, List, '[data-test="list"]'

  ###
  # Call the HTML <object>'s data url and provide super() with a
  # +root_element+ representing the response. Capybara doesn't
  # seem to load <object>s out of the box.
  def initialize(parent, root_element)
    path = root_element['data']
    open(Capybara.app_host + path, 'Cookie' => session_cookie) do |io|
      preview_root_element = Capybara::Node::Simple.new io.read
      super(parent, preview_root_element)
    end
  end

  def has_list?(list_name)
    !!list_named(list_name)
  end

  def list_named(list_name)
    lists.find { |list| list.title == list_name }
  end

  def has_availability_restriction?(text=nil)
    if text
      availability_restriction_el.text.strip.end_with? text
    else
      has_availability_restriction_el?
    end
  end
end
