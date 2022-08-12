require 'register_ingester_psc/snapshots/services/snapshot_importer'

RSpec.describe RegisterIngesterPsc::Snapshots::Services::SnapshotImporter do
  subject do
    described_class.new(
      stream_uploader_service: stream_uploader_service,
      snapshot_downloader: snapshot_downloader,
      stream_decompressor: stream_decompressor,
      s3_bucket: s3_bucket,
      split_size: split_size,
      max_lines: max_lines
    )
  end

  let(:stream_uploader_service) { double 'stream_uploader_service' }
  let(:snapshot_downloader) { double 'snapshot_downloader' }
  let(:stream_decompressor) { double 'stream_decompressor' }
  let(:s3_bucket) { 'fake_bucket' }
  let(:split_size) { 100 }
  let(:max_lines) { 500 }

  describe '#import_from_url' do
    it 'imports' do
      url = double 'url'
      dst_prefix = double 'dst_prefix'
      fake_tmpdir = 'fake_tmpdir'

      local_path = 'fake_tmpdir/snapshot.zip'
      fake_stream1 = double 'fake_stream1'
      fake_stream2 = double 'fake_stream2'

      allow(snapshot_downloader).to receive(:download)
      allow(stream_uploader_service).to receive(:upload_in_parts)

      expect(Dir).to receive(:mktmpdir).and_yield fake_tmpdir
      expect(File).to receive(:open).with(local_path, 'rb').and_yield fake_stream1
      expect(stream_decompressor).to receive(:with_deflated_stream).with(
        fake_stream1,
        compression: RegisterCommon::Decompressors::CompressionTypes::ZIP
      ).and_yield fake_stream2

      subject.import_from_url(url, dst_prefix)

      expect(snapshot_downloader).to have_received(:download).with(url: url, local_path: local_path)
      expect(stream_uploader_service).to have_received(:upload_in_parts).with(
        fake_stream2,
        s3_bucket: s3_bucket,
        s3_prefix: dst_prefix,
        split_size: split_size,
        max_lines: max_lines
      )
    end
  end
end
