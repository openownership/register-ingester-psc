require 'json'
require 'register_ingester_psc/streams/apps/stream_ingester'

RSpec.describe RegisterIngesterPsc::Streams::Apps::StreamIngester do
  subject { described_class.new(stream_client: stream_client, repository: repository) }

  let(:stream_client) { double 'stream_client' }
  let(:repository) { double 'repository' }

  describe '#call' do
    it 'stores received records in repository' do
      timepoint = double 'timepoint'
      record = double 'record'

      expect(stream_client).to receive(:read_stream).with(timepoint: timepoint).and_yield record
      allow(repository).to receive(:store)

      subject.call(timepoint: timepoint)

      expect(repository).to have_received(:store).with([record])
    end
  end
end
