class ManagedMenuFeature
  class << self
    def matches?(request)
      !!APP_CONFIG.dig(:features, :managed_menus)
    end
  end
end
