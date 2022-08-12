require 'register_ingester_psc/snapshots/services/snapshot_row_processor'

RSpec.describe RegisterIngesterPsc::Snapshots::Services::SnapshotRowProcessor do
  subject { described_class.new }

  describe '#process_row' do
    let(:valid_company_record) do
      {
        "company_number": "01234567",
        "data": {
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
        }
      }
    end

    it 'maps correctly' do
      company_record = subject.process_row valid_company_record

      expect(company_record.company_number).to eq "01234567"
      expect(company_record.data).to be_a RegisterSourcesPsc::Individual
      expect(company_record.data.etag).to eq "36c99208e0c14294355583c965e4c3f3"
      expect(company_record.data.notified_on).to eq "2016-04-06"
    end
  end
end
