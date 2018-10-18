require 'spec_helper'

describe 'lists' do
  describe 'POST to #create' do
    let(:account) { create :account }
    let(:user) { create :user, :account_admin, account: account }
    let(:establishment) { create :establishment, account: account }
    let(:params) do
      {
        account_id: account.id,
        establishment_id: establishment.id,
        list: {
          name: 'Zerts',
          type: 'other',
          beers_attributes: {
            "0" => {
              name: 'Ice Cream',
              price: '6.50',
              description: 'A chilly treat',
              position: 0,
              labels: ['Gluten Free', 'Vegetarian']
            }
          }
        }
      }
    end

    before do
      sign_in user
    end

    it 'saves the labels' do
      expect(establishment.lists.size).to eq 0
      post "/accounts/#{account.id}/establishments/#{establishment.id}/lists", params: params
      establishment.reload
      list = establishment.lists.last
      expect(list).to_not be_nil
      ice_cream = list.beers.first
      expect(ice_cream.labels.map(&:name)).to eq ['Gluten Free', 'Vegetarian']
    end
  end
end
