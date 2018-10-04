module ApplicationHelper
  def fingerprinted_asset(name)
    Rails.env.production? ? "#{name}-#{ASSET_FINGERPRINT}" : name
  end

  def active_class(path)
    request.fullpath == path && 'active'
  end

  def tab(path:, name:)
    content_tag(:li, class: "nav-item #{active_class(path)}") do
      link_to name, path, class: 'nav-link'
    end
  end

  def role_icon(user)
    if user.role == Role.manager
      css_class = 'float-right fa fa-user-o fa-lg'
      title = 'Admin'
    elsif current_user == user
      css_class = 'float-right fa fa-star fa-lg'
      title = 'You'
    else
      return
    end

    content_tag(:i, class: css_class, title: title) do
    end
  end

  def role_options
    Role.accessible_by(current_ability).map { |r| [r.name, r.id] }
  end

  def admin_user?
    user_signed_in? && current_user.role == Role.super_admin
  end

  def account_establishments(account)
    account.establishments.accessible_by(current_ability)
  end
end
