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
end
