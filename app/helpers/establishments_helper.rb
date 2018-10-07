module EstablishmentsHelper
  def add_new_button(account, establishment, type, enabled: true, text: 'Add New', icon: nil)
    css_classes = %w(btn btn-evrgn-outline-primary)
    css_classes << 'disabled' unless enabled
    if establishment.persisted?
      href = public_send("new_account_establishment_#{type}_path", account, establishment)
    else
      css_classes << 'disabled'
      href = ''
    end
    options = {
      class: css_classes.join(' '),
      data: {
        test: "add-#{type}".dasherize
      }
    }
    options.merge!(aria: { disabled: true }) unless enabled

    link_to(href, options) do
      opts = {}.tap do |h|
        h.merge!(class: "#{icon} btn-icon") if icon
      end
      tag.span do
        tag.span(text) + tag.span(opts)
      end
    end
  end

  def add_list_button(account, establishment)
    add_new_button account, establishment, :list, text: '+ List'
  end

  def add_menu_button(account, establishment, enabled: true)
    add_new_button account, establishment, :menu, {
      enabled: enabled,
      text: '+ Print',
      icon: 'far fa-file-pdf'
    }
  end

  def add_digital_display_menu_button(account, establishment, enabled: true)
    add_new_button account, establishment, :digital_display_menu, {
      enabled: enabled,
      text: '+ Digital Display',
      icon: 'fas fa-tv'
    }
  end

  def add_web_menu_button(account, establishment, enabled: true)
    add_new_button account, establishment, :web_menu, {
      enabled: enabled,
      text: '+ Web',
      icon: 'fas fa-code'
    }
  end

  def hide_menus_help?(establishment)
    establishment.menus.any? ||
    establishment.web_menus.any? ||
    establishment.digital_display_menus.any?
  end

  def google_my_business_location_opts(account)
    account.google_my_business_locations.map do |loc|
      [loc.location_name, loc.name]
    end
  end
end
