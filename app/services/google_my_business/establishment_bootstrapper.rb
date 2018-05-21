module GoogleMyBusiness
  class EstablishmentBootstrapper
    def initialize(account)
      @account = account
    end

    def bootstrap_menus
      @account.establishments.each do |est|
        MenuBootstrapper.call({
          establishment: est,
          gmb_location_id: est.google_my_business_location_id
        })
      end
    end
  end
end
