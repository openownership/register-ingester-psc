require 'register_ingester_psc/snapshots/apps/snapshot_ingester'

RSpec.describe RegisterIngesterPsc::Snapshots::Apps::SnapshotIngester do
  subject do
    described_class.new(
      s3_adapter:,
      snapshot_reader:,
      records_handler:,
      s3_bucket:,
      split_snapshots_s3_prefix:,
    )
  end

  let(:s3_adapter) { double 's3_adapter' }
  let(:snapshot_reader) { double 'snapshot_reader' }
  let(:records_handler) { double 'records_handler' }
  let(:s3_bucket) { double 's3_bucket' }
  let(:split_snapshots_s3_prefix) { 'split_snapshots/s3_prefix' }

  describe '#call' do
    it 'ingests files from S3 into records_handler' do
      import_id = 'import1'

      s3_paths = [double('s3_path1'), double('s3_path2')]
      records1 = [double('record1'), double('record2')]
      records2 = [double('record3'), double('record4')]

      expect(s3_adapter).to receive(:list_objects).with(
        s3_bucket:,
        s3_prefix: 'split_snapshots/s3_prefix/import_id=import1',
      ).and_return s3_paths

      expect(snapshot_reader).to receive(:read_from_s3).with(
        s3_bucket:,
        s3_path: s3_paths[0],
      ).and_yield records1

      expect(snapshot_reader).to receive(:read_from_s3).with(
        s3_bucket:,
        s3_path: s3_paths[1],
      ).and_yield records2

      allow(records_handler).to receive(:handle_records)

      subject.call(import_id:)

      expect(records_handler).to have_received(:handle_records).with(records1)
      expect(records_handler).to have_received(:handle_records).with(records2)
    end
  end
end
