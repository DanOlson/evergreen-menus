module EstablishmentsHelper
  STATES = {
    "AL" => "Alabama",
    "AK" => "Alaska",
    "AZ" => "Arizona",
    "AR" => "Arkansas",
    "CA" => "California",
    "CO" => "Colorado",
    "CT" => "Connecticut",
    "DE" => "Delaware",
    "DC" => "District Of Columbia",
    "FL" => "Florida",
    "GA" => "Georgia",
    "HI" => "Hawaii",
    "ID" => "Idaho",
    "IL" => "Illinois",
    "IN" => "Indiana",
    "IA" => "Iowa",
    "KS" => "Kansas",
    "KY" => "Kentucky",
    "LA" => "Louisiana",
    "ME" => "Maine",
    "MD" => "Maryland",
    "MA" => "Massachusetts",
    "MI" => "Michigan",
    "MN" => "Minnesota",
    "MS" => "Mississippi",
    "MO" => "Missouri",
    "MT" => "Montana",
    "NE" => "Nebraska",
    "NV" => "Nevada",
    "NH" => "New Hampshire",
    "NJ" => "New Jersey",
    "NM" => "New Mexico",
    "NY" => "New York",
    "NC" => "North Carolina",
    "ND" => "North Dakota",
    "OH" => "Ohio",
    "OK" => "Oklahoma",
    "OR" => "Oregon",
    "PA" => "Pennsylvania",
    "RI" => "Rhode Island",
    "SC" => "South Carolina",
    "SD" => "South Dakota",
    "TN" => "Tennessee",
    "TX" => "Texas",
    "UT" => "Utah",
    "VT" => "Vermont",
    "VA" => "Virginia",
    "WA" => "Washington",
    "WV" => "West Virginia",
    "WI" => "Wisconsin",
    "WY" => "Wyoming"
  }

  def state_options
    STATES.invert.to_a
  end

  def web_menus_json(establishment)
    account = establishment.account
    establishment.web_menus.order(:name).map do |menu|
      {
        id: menu.id,
        name: menu.name,
        editPath: edit_account_establishment_web_menu_path(account, establishment, menu),
        embedCode: make_embed_code(menu)
      }
    end.to_json
  end

  def make_embed_code(menu)
    if can?(:view_snippet, WebMenu)
      embed_code = MenuEmbedCode.new({
        web_menu: menu,
        menu_url: web_menu_url(menu.id)
      })

      <<~HTML.strip.html_safe
        <pre>
          <code>
  #{embed_code.generate_encoded}
          </code>
        </pre>
      HTML
    end
  end

  def add_new_button(account, establishment, type)
    css_classes = %w(btn btn-primary)
    if establishment.persisted?
      href = public_send("new_account_establishment_#{type}_path", account, establishment)
    else
      css_classes << 'disabled'
      href = ''
    end
    link_to('Add New', href, {
      class: css_classes.join(' '),
      data: {
        test: "add-#{type}".dasherize
      }
    })
  end

  def add_list_button(account, establishment)
    add_new_button account, establishment, :list
  end

  def add_menu_button(account, establishment)
    add_new_button account, establishment, :menu
  end

  def add_digital_display_menu_button(account, establishment)
    add_new_button account, establishment, :digital_display_menu
  end

  def add_web_menu_button(account, establishment)
    add_new_button account, establishment, :web_menu
  end

  def hide_lists_help?(establishment)
    establishment.lists.any?
  end

  def hide_menus_help?(establishment)
    establishment.menus.any?
  end

  def hide_displays_help?(establishment)
    establishment.digital_display_menus.any?
  end

  def hide_web_menus_help?(establishment)
    establishment.web_menus.any?
  end
end
