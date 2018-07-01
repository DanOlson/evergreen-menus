require 'spec_helper'

module Facebook
  describe Page do
    describe '#as_json' do
      let(:instance) do
        Page.new({
          'access_token' => 'asdf',
          'id' => '123',
          'name' => 'Good Page',
          'fan_count' => 3000
        })
      end

      let(:as_json) { instance.as_json }

      it 'excludes access_token' do
        expect(as_json).to_not have_key 'access_token'
      end

      it 'includes id' do
        expect(as_json['id']).to eq '123'
      end

      it 'includes name' do
        expect(as_json['name']).to eq 'Good Page'
      end

      it 'includes fan_count' do
        expect(as_json['fan_count']).to eq 3000
      end
    end
  end
end
