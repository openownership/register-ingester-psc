require 'json'
require 'register_ingester_psc/streams/clients/psc_stream'

RSpec.describe RegisterIngesterPsc::Streams::Clients::PscStream do
  subject { described_class.new(http_adapter: http_adapter, api_key: api_key) }

  let(:sample_record) do
    {
      data: {
        etag: "36c99208e0c14294355583c965e4c3f3",
        "kind": "individual-person-with-significant-control",
        "name_elements": {
          "forename": "Joe",
          "surname": "Bloggs"
        },
        "nationality": "British",
        "country_of_residence": "United Kingdom",
        "notified_on": "2016-04-06",
        "address": {
          "premises": "123 Main Street",
          "locality": "Example Town",
          "region": "Exampleshire",
          "postal_code": "EX4 2MP"
        },
        "date_of_birth": {
          "month": 10,
          "year": 1955
        },
        "natures_of_control": [
          "ownership-of-shares-25-to-50-percent",
          "voting-rights-25-to-50-percent"
        ],
        "links": {
          "self": "/company/01234567/persons-with-significant-control/individual/abcdef123456789"
        }
      },
      event: {
        fields_changed: ['field1'],
        published_at: '2022-08-10',
        timepoint: 123,
        type: 'changed'
      },
      resource_id: 'resource_id',
      resource_kind: 'company-profile#company-profile',
      resource_uri: 'resource_uri'
    }.to_json
  end

  let(:http_adapter) { double 'http_adapter' }
  let(:api_key) { 'api_key' }

  describe '#read_stream' do
    context 'when timepoint is provided' do
      it 'streams from PSC stream API' do
        timepoint = double 'timepoint'

        expect(http_adapter).to receive(:get).with(
          "https://stream.companieshouse.gov.uk/persons-with-significant-control",
          params: {
            timepoint: timepoint
          },
          headers: {
            Authorization: "Basic YXBpX2tleTo="
          }
        ).and_yield sample_record

        records = []
        subject.read_stream(timepoint: timepoint) do |record|
          records << record
        end

        record = records.first
        expect(record).to be_a RegisterIngesterPsc::Streams::PscStream
      end
    end
  end
end
