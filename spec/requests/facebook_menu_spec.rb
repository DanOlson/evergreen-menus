require 'spec_helper'

describe 'POST to /facebook/tab' do
  let(:menu) { create :google_menu, establishment: establishment }
  let(:signed_request) do
    'OX3bVK7a9BR0_ZJjyl8qr4hxdbyugEWnVDis52dYJXg.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjE1MjkxMjUyMDAsImlzc3VlZF9hdCI6MTUyOTExODcwMiwib2F1dGhfdG9rZW4iOiJFQUFhSVE0U2pyY3NCQUZaQk9aQ2p5dDlneTVDdW11MFE4NUU2Q1FaQk12aWd6YnlQWDBrSmt2YjJTeEJJRVNmS2N4d3pNZjg3TE1nWkNpVmd6ZFZGZFZHMGpxSGRLbnZPWkFybEJmODFIU0JyV0hpNVVpamdVc3pjSDQ5OXNCdGlaQ0JhTUg3a1FGTGNxNlg2WkM0UTFPcGVTSDVZa1pBSUE5QVJBamQ3WkN0R20zb096Y3JmNE42TUxVMVdTdzRVWkNHSjVmMzF3QmxpUk5DZ0lwVjBJUWd0bTYiLCJwYWdlIjp7ImlkIjoiMjI0NTQ0NzQxNjgzNDg5IiwiYWRtaW4iOnRydWV9LCJ1c2VyIjp7ImNvdW50cnkiOiJ1cyIsImxvY2FsZSI6ImVuX1VTIiwiYWdlIjp7Im1pbiI6MjF9fSwidXNlcl9pZCI6IjEyNzU5MDA5ODEzMzYzNyJ9'
  end

  before do
    list = create :list, :beer, :with_items, name: 'Tap Beer', establishment: establishment
    menu.google_menu_lists.create({
      position: 0,
      show_price_on_menu: true,
      show_description_on_menu: true,
      list: list
    })
  end

  context 'with an active account' do
    context 'and a valid facebook page id' do
      let(:establishment) { create :establishment, facebook_page_id: '224544741683489' }

      it 'returns the correct menu content' do
        post '/facebook/tab', params: { signed_request: signed_request }
        expect(response).to have_http_status :ok
        expect(response.body).to include 'Tap Beer'
      end
    end

    context 'and no facebook page id' do
      let(:establishment) { create :establishment }

      it 'returns 404' do
        post '/facebook/tab', params: { signed_request: signed_request }
        expect(response).to have_http_status :not_found
        expect(response.body).to include 'This page is not connected to Evergreen Menus. Please sign up at https://evergreenmenus.com'
      end
    end
  end

  context 'with an inactive account' do
    let(:account) { create :account, active: false }
    let(:establishment) { create :establishment, account: account, facebook_page_id: '224544741683489' }

    it 'returns 402' do
      post '/facebook/tab', params: { signed_request: signed_request }
      expect(response).to have_http_status :payment_required
      expect(response.body).to include 'This page is not connected to Evergreen Menus. Please sign up at https://evergreenmenus.com'
    end
  end
end
