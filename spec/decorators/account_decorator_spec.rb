require 'spec_helper'

describe AccountDecorator do
  it 'decorates an account' do
    instance = build_stubbed(:account).decorate
    expect(instance).to be_decorated_with AccountDecorator
  end

  it 'has a google_my_business_service' do
    account = build_stubbed :account
    instance = account.decorate
    expect(instance.google_my_business_service.account).to eq account
  end

  it 'has a facebook_service' do
    account = build_stubbed :account
    instance = account.decorate
    expect(instance.facebook_service.account).to eq account
  end

  describe '#google_my_business_accounts' do
    let(:account) { build_stubbed :account }
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

  describe '#facebook_pages' do
    let(:account) { build_stubbed :account }
    let(:instance) do
      AccountDecorator.new(account, facebook_service: mock_fb_service)
    end
    let(:mock_fb_service) do
      double(Facebook::Service, pages: fb_pages)
    end
    let(:fb_pages) { [Facebook::Page.new] }

    it 'fetches the pages from the facebook_service' do
      expect(instance.facebook_pages).to eq fb_pages
    end
  end

  describe '#credit_card_info', :vcr do
    let(:account) { build_stubbed :account, stripe_id: stripe_id }
    let(:instance) do
      AccountDecorator.new(account)
    end
    subject { instance.credit_card_info }

    context 'when the account has a stripe_id' do
      let(:stripe_id) { 'cus_DHp2EbahQyQruN' }

      it { is_expected.to eq 'Visa ending in 4242' }

      context 'but the Stripe customer cannot be found' do
        let(:stripe_id) { 'cus_abc' }
        it { is_expected.to eq nil }
      end

      context 'but the customer does not have a card' do
        # Jeff Lebowski has no card
        let(:stripe_id) { 'cus_DVe73qX1zqGHby' }
        it { is_expected.to eq nil }
      end
    end

    context 'when the account has no stripe_id' do
      let(:stripe_id) { nil }
      it { is_expected.to eq nil }
    end
  end
end
