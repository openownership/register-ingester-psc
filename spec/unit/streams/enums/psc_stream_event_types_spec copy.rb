require 'register_ingester_psc/streams/enums/psc_stream_event_kinds'

RSpec.describe RegisterIngesterPsc::Streams::PscStreamEventKinds do
  context "when value is 'changed'" do
    let(:value) { 'changed' }

    it 'maps value' do
      expect(described_class[value]).to eq value
    end
  end
end
