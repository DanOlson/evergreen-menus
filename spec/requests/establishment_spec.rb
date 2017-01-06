require 'spec_helper'

describe 'creating establishments' do
  let(:account) { create :account }
  let(:user) { create :user, account: account }

  before do
    sign_in user
  end

  ###
  # Geocoding requests are mocked in tests. See spec/support/geocoder.rb
  it 'is geocoded when created' do
    params = {
      account_id: account.id,
      establishment: {
        name: "Lebowski's",
        url: "lebowski.me",
        street_address: '312 Central Ave SE',
        city: 'Minneapolis',
        state: 'MN',
        postal_code: '55414'
      }
    }

    post "/accounts/#{account.id}/establishments", params: params
    expect(account.establishments.size).to eq 1
    establishment = account.establishments.last
    expect(establishment.latitude).to eq BigDecimal.new("44.986861")
    expect(establishment.longitude).to eq BigDecimal.new("-93.254333")
  end

  ###
  # Geocoding requests are mocked in tests. See spec/support/geocoder.rb
  it 'is geocoded when address is updated' do
    establishment = account.establishments.create!({
      name: "Walter's",
      url: 'sobchakswateringhole.com',
      street_address: '312 Central Ave SE',
      city: 'Minneapolis',
      state: 'MN',
      postal_code: '55414'
    })

    expect(establishment.latitude).to eq BigDecimal.new("44.986861")
    expect(establishment.longitude).to eq BigDecimal.new("-93.254333")

    params = {
      account_id: account.id,
      establishment: {
        name: "Lebowski's",
        url: "lebowski.me",
        street_address: '2933 Lyndale Ave S',
        city: 'Minneapolis',
        state: 'MN',
        postal_code: '55408'
      }
    }

    put "/accounts/#{account.id}/establishments/#{establishment.id}", params: params

    establishment.reload
    expect(establishment.latitude).to eq BigDecimal.new("44.949225")
    expect(establishment.longitude).to eq BigDecimal.new("-93.287703")
  end
end
