require 'spec_helper'

describe Label do
  describe '.from' do
    context 'string' do
      it 'returns a Label with a name of +string+' do
        foo = Label.from('foo')
        bar = Label.from('bar')
        expect(foo.name).to eq 'foo'
        expect(bar.name).to eq 'bar'
      end
    end

    context 'another Label instance' do
      it 'returns the given instance' do
        label = Label.new(name: 'Sweet')
        expect(Label.from(label)).to eq label
      end
    end
  end
end
