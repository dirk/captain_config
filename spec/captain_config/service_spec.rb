require 'spec_helper'

RSpec.describe ConfigCaptain::Service do
  subject do
    ConfigCaptain::Service.new load_after_initialize: false do
      some_boolean :boolean, default: false
      some_integer :integer
      some_string :string
    end
  end

  after do
    ConfigCaptain::BaseConfig.delete_all
  end

  describe '#[]' do
    context 'when not loaded' do
      it 'raises error' do
        expect {
          subject[:some_boolean]
        }.to raise_error(/not loaded/i)
      end
    end

    context 'when loaded' do
      before do
        subject.load
      end

      describe 'some_boolean' do
        it 'uses default' do
          expect(subject[:some_boolean]).to eq false
        end

        it 'returns value if set' do
          subject[:some_boolean] = true
          expect(subject[:some_boolean]).to eq true
          # Check that it's still set after we reload.
          subject.load
          expect(subject[:some_boolean]).to eq true
        end
      end
    end
  end
end
