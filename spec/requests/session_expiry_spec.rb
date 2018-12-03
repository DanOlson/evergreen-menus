require 'spec_helper'

describe 'session expiry' do
  let(:user) { create :user }

  before do
    post user_session_path, params: {
      username: user.username,
      password: user.password
    }
  end

  it 'expires after one day' do
    expiry = cookies.get_cookie('_evergreen_session').expires
    expected = (Time.now + 1.day).utc
    expect(expiry).to be_within(1.minute).of expected
  end
end
