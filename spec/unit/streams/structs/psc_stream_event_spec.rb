require 'register_ingester_psc/streams/structs/psc_stream_event'

RSpec.describe RegisterIngesterPsc::Streams::PscStreamEvent do
  let(:valid_params) do
    {
      fields_changed: ['field1'],
      published_at: '2022-08-10',
      timepoint: 123,
      type: 'changed'
    }
  end

  it 'allows valid params' do
    psc_stream_event = described_class[valid_params]

    expect(psc_stream_event.fields_changed).to eq ['field1']
    expect(psc_stream_event.published_at).to eq '2022-08-10'
    expect(psc_stream_event.timepoint).to eq 123
    expect(psc_stream_event.type).to eq 'changed'
  end
end
