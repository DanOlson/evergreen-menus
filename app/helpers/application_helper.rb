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

  def role_options
    Role.accessible_by(current_ability).map { |r| [r.name, r.id] }
  end
end
