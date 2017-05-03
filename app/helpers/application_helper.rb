module ApplicationHelper
  def fingerprinted_asset(name)
    Rails.env.production? ? "#{name}-#{ASSET_FINGERPRINT}" : name
  end

  def active_class(path)
    request.fullpath == path && 'active'
  end

  def tab(path:, name:)
    content_tag(:li, class: active_class(path)) do
      link_to name, path
    end
  end

  def role_icon(user)
    if current_user == user
      css_class = 'pull-right glyphicon glyphicon-star'
      title = 'You'
    elsif user.role == Role.manager
      css_class = 'pull-right glyphicon glyphicon-user'
      title = 'Manager'
    else
      return
    end

    content_tag(:span, class: css_class, title: title) do
    end
  end

  def role_options
    Role.accessible_by(current_ability).map { |r| [r.name, r.id] }
  end

  def admin_user?
    user_signed_in? && current_user.role == Role.admin
  end
end
