require 'register_ingester_psc/snapshots/services/snapshot_reader'

RSpec.describe RegisterIngesterPsc::Snapshots::Services::SnapshotReader do
  subject do
    described_class.new(
      s3_adapter:,
      row_processor:,
      decompressor:,
      parser:,
      batch_size:,
    )
  end

  let(:s3_adapter) { double 's3_adapter' }
  let(:row_processor) { double 'row_processor' }
  let(:decompressor) { double 'decompressor' }
  let(:parser) { double 'parser' }
  let(:batch_size) { double 'batch_size' }
  let(:file_format) { double 'file_format' }
  let(:compression) { double 'compression' }

  let(:file_reader_service) { double 'file_reader_service' }
  let(:fake_record_batch) { [fake_record1, fake_record2] }
  let(:fake_record1) { double 'fake_record1' }
  let(:fake_record2) { double 'fake_record2' }
  let(:row1) { double 'row1' }
  let(:row2) { double 'row2' }

  before do
    expect(RegisterCommon::Services::FileReader).to receive(:new).with(
      s3_adapter:,
      decompressor:,
      parser:,
      batch_size:,
    ).and_return file_reader_service

    expect(row_processor).to receive(:process_row).with(fake_record1).and_return row1
    expect(row_processor).to receive(:process_row).with(fake_record2).and_return row2
  end

  describe '#read_from_s3' do
    it 'yields processed rows' do
      s3_bucket = double 's3_bucket'
      s3_path = double 's3_path'

      expect(file_reader_service).to receive(:read_from_s3).with(
        s3_bucket:,
        s3_path:,
        file_format:,
        compression:,
      ).and_yield fake_record_batch

      results = []
      subject.read_from_s3(
        s3_bucket:,
        s3_path:,
        file_format:,
        compression:,
      ) do |batch|
        results << batch
      end

      expect(results).to eq(
        [
          [row1, row2],
        ],
      )
    end

    it 'yields processed rows with default settings' do
      s3_bucket = double 's3_bucket'
      s3_path = double 's3_path'

      expect(file_reader_service).to receive(:read_from_s3).with(
        s3_bucket:,
        s3_path:,
        file_format: 'json',
        compression: 'gzip',
      ).and_yield fake_record_batch

      results = []
      subject.read_from_s3(s3_bucket:, s3_path:) do |batch|
        results << batch
      end

      expect(results).to eq(
        [
          [row1, row2],
        ],
      )
    end
  end

  describe '#read_from_local_path' do
    it 'yields processed rows' do
      file_path = double 'file_path'

      expect(file_reader_service).to receive(:read_from_local_path).with(
        file_path,
        file_format:,
        compression:,
      ).and_yield fake_record_batch

      results = []
      subject.read_from_local_path(
        file_path,
        file_format:,
        compression:,
      ) do |batch|
        results << batch
      end

      expect(results).to eq(
        [
          [row1, row2],
        ],
      )
    end

    it 'yields processed rows with default settings' do
      file_path = double 'file_path'

      expect(file_reader_service).to receive(:read_from_local_path).with(
        file_path,
        file_format: 'json',
        compression: 'gzip',
      ).and_yield fake_record_batch

      results = []
      subject.read_from_local_path(file_path) do |batch|
        results << batch
      end

      expect(results).to eq(
        [
          [row1, row2],
        ],
      )
    end
  end

  describe '#read_from_stream' do
    it 'yields processed rows' do
      stream = double 'stream'

      expect(file_reader_service).to receive(:read_from_stream).with(
        stream,
        file_format:,
        compression:,
      ).and_yield fake_record_batch

      results = []
      subject.read_from_stream(
        stream,
        file_format:,
        compression:,
      ) do |batch|
        results << batch
      end

      expect(results).to eq(
        [
          [row1, row2],
        ],
      )
    end

    it 'yields processed rows with default settings' do
      stream = double 'stream'

      expect(file_reader_service).to receive(:read_from_stream).with(
        stream,
        file_format: 'json',
        compression: 'gzip',
      ).and_yield fake_record_batch

      results = []
      subject.read_from_stream(stream) do |batch|
        results << batch
      end

      expect(results).to eq(
        [
          [row1, row2],
        ],
      )
    end
  end
end
