require 'register_ingester_psc/snapshots/services/snapshot_link_scraper'

RSpec.describe RegisterIngesterPsc::Snapshots::Services::SnapshotLinkScraper do
  subject { described_class.new(http_adapter:, source_url:) }

  let(:http_adapter) { double 'http_adapter' }
  let(:source_url) { 'http://fake.companieshouse.gov.fake/en_pscdata.html' }

  describe '#list_links' do
    it 'works' do
      content = File.read('spec/fixtures/files/en_pscdata.html')
      html_response = double 'response', body: content

      expect(http_adapter).to receive(:get).with(source_url).and_return html_response

      expect(subject.list_links).to eq(
        (1..20).map { |i| "http://fake.companieshouse.gov.fake/psc-snapshot-2022-02-09_#{i}of20.zip" },
      )
    end
  end
end
