require 'spec_helper'

module Facebook
  describe SignedRequest do
    let(:instance) { SignedRequest.new signed_request }

    describe '.parse' do
      context 'when the signature request is valid' do
        let(:signed_request) do
          'OX3bVK7a9BR0_ZJjyl8qr4hxdbyugEWnVDis52dYJXg.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjE1MjkxMjUyMDAsImlzc3VlZF9hdCI6MTUyOTExODcwMiwib2F1dGhfdG9rZW4iOiJFQUFhSVE0U2pyY3NCQUZaQk9aQ2p5dDlneTVDdW11MFE4NUU2Q1FaQk12aWd6YnlQWDBrSmt2YjJTeEJJRVNmS2N4d3pNZjg3TE1nWkNpVmd6ZFZGZFZHMGpxSGRLbnZPWkFybEJmODFIU0JyV0hpNVVpamdVc3pjSDQ5OXNCdGlaQ0JhTUg3a1FGTGNxNlg2WkM0UTFPcGVTSDVZa1pBSUE5QVJBamQ3WkN0R20zb096Y3JmNE42TUxVMVdTdzRVWkNHSjVmMzF3QmxpUk5DZ0lwVjBJUWd0bTYiLCJwYWdlIjp7ImlkIjoiMjI0NTQ0NzQxNjgzNDg5IiwiYWRtaW4iOnRydWV9LCJ1c2VyIjp7ImNvdW50cnkiOiJ1cyIsImxvY2FsZSI6ImVuX1VTIiwiYWdlIjp7Im1pbiI6MjF9fSwidXNlcl9pZCI6IjEyNzU5MDA5ODEzMzYzNyJ9'
        end

        it 'returns the parsed payload' do
          result = instance.parse

          expect(result['algorithm']).to eq 'HMAC-SHA256'
          expect(result['page']['id']).to eq '224544741683489'
        end
      end

      context 'when the signature is invalid' do
        let(:signed_request) do
          'Mzk3ZGRiNTRhZWRhZjQxNDc0ZmQ5MjYzY2E1ZjJhYWY4ODcxNzViY2FlODA0NWE3NTQzOGFjZTc2NzU4MjU3OA.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjE1MjkxMjUyMDAsImlzc3VlZF9hdCI6MTUyOTExODcwMiwib2F1dGhfdG9rZW4iOiJFQUFhSVE0U2pyY3NCQUZaQk9aQ2p5dDlneTVDdW11MFE4NUU2Q1FaQk12aWd6YnlQWDBrSmt2YjJTeEJJRVNmS2N4d3pNZjg3TE1nWkNpVmd6ZFZGZFZHMGpxSGRLbnZPWkFybEJmODFIU0JyV0hpNVVpamdVc3pjSDQ5OXNCdGlaQ0JhTUg3a1FGTGNxNlg2WkM0UTFPcGVTSDVZa1pBSUE5QVJBamQ3WkN0R20zb096Y3JmNE42TUxVMVdTdzRVWkNHSjVmMzF3QmxpUk5DZ0lwVjBJUWd0bTYiLCJwYWdlIjp7ImlkIjoiMjI0NTQ0NzQxNjgzNDg5IiwiYWRtaW4iOnRydWV9LCJ1c2VyIjp7ImNvdW50cnkiOiJ1cyIsImxvY2FsZSI6ImVuX1VTIiwiYWdlIjp7Im1pbiI6MjF9fSwidXNlcl9pZCI6IjEyNzU5MDA5ODEzMzYzNyJ9'
        end

        it 'returns nil' do
          result = instance.parse
          expect(result).to eq nil
        end
      end

      context 'when the signed request is just bad' do
        let(:signed_request) { 'asdf' }

        it 'returns nil' do
          result = instance.parse
          expect(result).to eq nil
        end
      end
    end
  end
end
