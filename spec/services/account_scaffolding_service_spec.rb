require 'spec_helper'

describe AccountScaffoldingService do
  describe '.call' do
    let(:instance) { instance_double AccountScaffoldingService, call: nil }
    let(:account) { instance_double Account }

    it 'delegates to an instance' do
      allow(AccountScaffoldingService).to receive(:new).with(account) { instance }
      AccountScaffoldingService.call account
      expect(instance).to have_received :call
    end
  end

  describe '#call' do
    let(:instance) { AccountScaffoldingService.new account }
    let(:account) { create :account, :with_subscription }

    it 'creates an establishment for the account' do
      expect {
        instance.call
      }.to change { account.establishments.count }.by 1
    end

    it 'creates 5 lists for the establishment' do
      expect {
        instance.call
      }.to change(List, :count).by 5
      establishment = account.establishments.last
      expect(establishment.lists.size).to eq 5
    end

    it 'creates menu items for each list' do
      instance.call
      establishment = account.establishments.last
      expect(establishment.lists).to all satisfy { |list| list.beers.any? }
    end

    it 'creates a web menu for the establishment' do
      expect {
        instance.call
      }.to change(WebMenu, :count).by 1
      establishment = account.establishments.last
      web_menu = establishment.web_menus.last
      expect(web_menu.lists.map(&:name)).to match_array [
        'Appetizers',
        'Burgers',
        'Entrees'
      ]
    end

    it 'creates a print menu for the establishment' do
      expect {
        instance.call
      }.to change(Menu, :count).by 1
      establishment = account.establishments.last
      menu = establishment.menus.last
      expect(menu.lists.map(&:name)).to match_array [
        'Appetizers',
        'Burgers',
        'Entrees'
      ]
    end

    it 'creates a digital display menu for the establishment' do
      expect {
        instance.call
      }.to change(DigitalDisplayMenu, :count).by 1
      establishment = account.establishments.last
      digital_display_menu = establishment.digital_display_menus.last
      expect(digital_display_menu.lists.map(&:name)).to match_array [
        'Beer',
        'Wine',
      ]
    end
  end
end
