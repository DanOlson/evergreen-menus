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
  end
end
