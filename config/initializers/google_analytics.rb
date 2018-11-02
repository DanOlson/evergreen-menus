module GoogleAnalytics
  TRACKING_IDS_BY_PROPERTY = {
    admin: 'UA-118310782-2',
    facebook_tab: 'UA-118310782-3',
    marketing: 'UA-118310782-1'
  }

  class << self
    def tracking_id_for(property)
      TRACKING_IDS_BY_PROPERTY.fetch property
    end
  end
end
