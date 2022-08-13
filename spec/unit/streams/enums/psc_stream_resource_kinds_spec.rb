require 'register_ingester_psc/streams/enums/psc_stream_resource_kinds'

RSpec.describe RegisterIngesterPsc::Streams::PscStreamResourceKinds do
  context "when value is 'company-profile#company-profile'" do
    let(:value) { 'company-profile#company-profile' }

    it 'maps value' do
      expect(described_class[value]).to eq value
    end
  end
end
