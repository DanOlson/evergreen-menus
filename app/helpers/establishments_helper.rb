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

  def list_json(list)
    list.as_json.merge(beers: list.beers.as_json).to_json
  end

  def lists_json(establishment)
    account = establishment.account
    establishment.lists.map do |list|
      {
        id: list.id,
        name: list.name,
        edit_path: edit_account_establishment_list_path(account, establishment, list),
        html_snippet: make_snippet(list)
      }
    end.to_json
  end

  def menu_json(menu)
    available_lists = menu.establishment.lists - menu.lists
    lists = menu.menu_lists.includes(:list).map do |ml|
      {
        menu_list_id: ml.id,
        show_price_on_menu: ml.show_price_on_menu
      }.merge(ml.list.attributes)
    end
    menu.as_json.merge({
      lists: lists.as_json,
      listsAvailable: available_lists.as_json
    }).to_json
  end

  def make_snippet(list)
    if can?(:view_snippet, List)
      snippet = ListHtmlSnippet.new({
        list: list,
        menu_url: menu_list_url(list.id)
      })

      <<~HTML.html_safe
        <pre>
          <code>
  #{snippet.generate_encoded}
          </code>
        </pre>
      HTML
    end
  end

  def add_list_button(account, establishment)
    css_classes = %w(btn btn-primary)
    if establishment.persisted?
      href = new_account_establishment_list_path(account, establishment)
    else
      css_classes << 'disabled'
      href = ''
    end
    link_to('Add List', href, {
      class: css_classes.join(' '),
      data: {
        test: 'add-list'
      }
    })
  end

  def add_menu_button(account, establishment)
    css_classes = %w(btn btn-primary)
    if establishment.persisted?
      href = new_account_establishment_menu_path(account, establishment)
    else
      css_classes << 'disabled'
      href = ''
    end
    link_to('Add Menu', href, {
      class: css_classes.join(' '),
      data: {
        test: 'add-menu'
      }
    })
  end
end
