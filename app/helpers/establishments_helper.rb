module EstablishmentsHelper
  def add_new_button(account, establishment, type, enabled: true, text: 'Add New')
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

    link_to text, href, options
  end

  def add_list_button(account, establishment)
    add_new_button account, establishment, :list, text: '+ List'
  end

  def add_menu_button(account, establishment, enabled: true)
    add_new_button account, establishment, :menu, {
      enabled: enabled,
      text: '+ Print Menu'
    }
  end

  def add_digital_display_menu_button(account, establishment, enabled: true)
    add_new_button account, establishment, :digital_display_menu, {
      enabled: enabled,
      text: '+ Digital Display Menu'
    }
  end

  def add_web_menu_button(account, establishment, enabled: true)
    add_new_button account, establishment, :web_menu, {
      enabled: enabled,
      text: '+ Web Menu'
    }
  end

  def hide_menus_help?(establishment)
    establishment.menus.any? ||
    establishment.web_menus.any? ||
    establishment.digital_display_menus.any?
  end
end
