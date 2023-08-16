require 'register_ingester_psc/snapshots/apps/snapshot_discoverer'

RSpec.describe RegisterIngesterPsc::Snapshots::Apps::SnapshotDiscoverer do
  subject do
    described_class.new(
      snapshot_link_scraper:,
      snapshot_importer:,
      split_snapshots_s3_prefix:,
    )
  end

  let(:snapshot_link_scraper) { double 'snapshot_link_scraper' }
  let(:snapshot_importer) { double 'snapshot_importer' }
  let(:split_snapshots_s3_prefix) { 'split_snapshots_s3_prefix' }

  describe '#call' do
    it 'imports from url' do
      url1 = double 'url1'
      url2 = double 'url2'
      import_id = 'import1'

      expect(snapshot_link_scraper).to receive(:list_links).and_return([url1, url2])

      allow(snapshot_importer).to receive(:import_from_url)

      subject.call(import_id:)

      expect(snapshot_importer).to have_received(:import_from_url).with(
        url1, "split_snapshots_s3_prefix/import_id=import1/url_index=0"
      )
      expect(snapshot_importer).to have_received(:import_from_url).with(
        url2, "split_snapshots_s3_prefix/import_id=import1/url_index=1"
      )
    end
  end
end
