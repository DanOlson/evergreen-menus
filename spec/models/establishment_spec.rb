require 'spec_helper'

describe Establishment do
  describe 'google_my_business_location_id' do
    it 'enforces uniqueness' do
      establishment1 = create :establishment, google_my_business_location_id: 'foo'
      establishment2 = build :establishment

      expect(establishment1).to be_valid
      expect(establishment2).to be_valid

      establishment2.google_my_business_location_id = 'foo'
      expect(establishment2).to_not be_valid
      expect(establishment2.errors[:google_my_business_location_id]).to eq ['has already been taken']
    end

    it 'allows null' do
      establishment1 = create :establishment, google_my_business_location_id: nil
      establishment2 = build :establishment, google_my_business_location_id: nil

      expect(establishment1).to be_valid
      expect(establishment2).to be_valid
    end

    it 'allows empty string' do
      establishment1 = create :establishment, google_my_business_location_id: ''
      establishment2 = build :establishment, google_my_business_location_id: ''

      expect(establishment1).to be_valid
      expect(establishment2).to be_valid
    end
  end

  describe 'facebook_page_id' do
    it 'enforces uniqueness' do
      establishment1 = create :establishment, facebook_page_id: 'foo'
      establishment2 = build :establishment

      expect(establishment1).to be_valid
      expect(establishment2).to be_valid

      establishment2.facebook_page_id = 'foo'
      expect(establishment2).to_not be_valid
      expect(establishment2.errors[:facebook_page_id]).to eq ['has already been taken']
    end

    it 'enforces uniqueness when nested attributes are simultaneously assigned' do
      account = create :account
      establishment1 = create :establishment, name: 'a', account: account
      establishment2 = create :establishment, name: 'b', account: account
      account.reload
      account.establishments_attributes = {
        '0' => { id: establishment1.id, facebook_page_id: 'asdf' },
        '1' => { id: establishment2.id, facebook_page_id: 'asdf' }
      }
      expect(account).to_not be_valid
      expect(account.errors.messages[:"establishments[0].facebook_page_id"].first).to eq 'has already been taken'
      expect(account.errors.messages[:"establishments[1].facebook_page_id"].first).to eq 'has already been taken'

      account.establishments_attributes = {
        '0' => { id: establishment1.id, facebook_page_id: '' },
        '1' => { id: establishment2.id, facebook_page_id: '' }
      }
      expect(account).to be_valid
    end

    it 'allows null' do
      establishment1 = create :establishment, facebook_page_id: nil
      establishment2 = build :establishment, facebook_page_id: nil

      expect(establishment1).to be_valid
      expect(establishment2).to be_valid
    end

    it 'allows empty string' do
      establishment1 = create :establishment, facebook_page_id: ''
      establishment2 = build :establishment, facebook_page_id: ''

      expect(establishment1).to be_valid
      expect(establishment2).to be_valid
    end
  end
end
