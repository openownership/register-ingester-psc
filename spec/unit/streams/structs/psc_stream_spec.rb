require 'register_ingester_psc/streams/structs/psc_stream'

RSpec.describe RegisterIngesterPsc::Streams::PscStream do
  let(:valid_params) do
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
    }
  end

  it 'allows valid params' do
    psc_stream = described_class[valid_params]

    expect(psc_stream.data).to be_a RegisterSourcesPsc::Individual
    expect(psc_stream.data.etag).to eq "36c99208e0c14294355583c965e4c3f3"
    expect(psc_stream.data.notified_on).to eq "2016-04-06"

    expect(psc_stream.resource_id).to eq 'resource_id'
    expect(psc_stream.resource_kind).to eq 'company-profile#company-profile'
    expect(psc_stream.resource_uri).to eq 'resource_uri'

    expect(psc_stream.event).to be_a RegisterIngesterPsc::Streams::PscStreamEvent
    expect(psc_stream.event.fields_changed).to eq ['field1']
    expect(psc_stream.event.published_at).to eq '2022-08-10'
    expect(psc_stream.event.timepoint).to eq 123
    expect(psc_stream.event.type).to eq 'changed'
  end
end
