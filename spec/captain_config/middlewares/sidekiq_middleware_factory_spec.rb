require 'spec_helper'

require 'timecop'

RSpec.describe CaptainConfig::SidekiqMiddlewareFactory do
  describe 'middleware' do
    subject { described_class.build }

    let(:service) { double CaptainConfig::Service }

    before do
      allow(CaptainConfig::Service).to receive(:last_created_service)
        .and_return(service)
    end

    def fake_call
      subject.new.call(nil, nil, nil) do
        nil
      end
    end

    it 'loads after the interval has passed' do
      expect(service).to receive(:load).exactly(3).times

      Timecop.freeze do
        subject.load

        Timecop.freeze(subject.interval + 0.1) do
          fake_call

          Timecop.freeze(subject.interval + 0.1) do
            fake_call
          end
        end
      end
    end

    it "doesn't load if the interval hasn't passed" do
      expect(service).to receive(:load).once

      Timecop.freeze do
        subject.load

        Timecop.freeze(subject.interval - 0.1) do
          fake_call
        end
      end
    end
  end
end
