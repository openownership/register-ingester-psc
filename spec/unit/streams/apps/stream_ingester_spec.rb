require 'json'
require 'register_ingester_psc/streams/apps/stream_ingester'

RSpec.describe RegisterIngesterPsc::Streams::Apps::StreamIngester do
  subject { described_class.new(stream_client: stream_client, records_handler: records_handler) }

  let(:stream_client) { double 'stream_client' }
  let(:records_handler) { double 'records_handler' }

  describe '#call' do
    it 'stores received records in repository' do
      timepoint = double 'timepoint'
      record = double 'record'

      expect(stream_client).to receive(:read_stream).with(timepoint: timepoint).and_yield record
      allow(records_handler).to receive(:handle_records)

      subject.call(timepoint: timepoint)

      expect(records_handler).to have_received(:handle_records).with([record])
    end
  end
end
