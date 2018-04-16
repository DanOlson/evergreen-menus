require 'spec_helper'

describe AccountDecorator do
  it 'decorates an account' do
    instance = build_stubbed(:account).decorate
    expect(instance).to be_decorated_with AccountDecorator
  end

  it 'has a google_my_business_service' do
    account = build_stubbed(:account)
    instance = account.decorate
    expect(instance.google_my_business_service.account).to eq account
  end

  describe '#google_my_business_accounts' do
    let(:account) { build_stubbed(:account) }
    let(:instance) do
      AccountDecorator.new(account, google_my_business_service: mock_gmb_service)
    end
    let(:gmb_accounts) { [GoogleMyBusiness::Account.new({})] }
    let(:mock_gmb_service) do
      double(GoogleMyBusiness::Service, accounts: gmb_accounts)
    end

    it 'fetches the accounts from the google_my_business_service' do
      expect(instance.google_my_business_accounts).to eq gmb_accounts
    end
  end
end
