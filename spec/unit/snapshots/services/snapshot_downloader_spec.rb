require 'tmpdir'
require 'register_ingester_psc/snapshots/services/snapshot_downloader'

RSpec.describe RegisterIngesterPsc::Snapshots::Services::SnapshotDownloader do
  subject { described_class.new(http_adapter: http_adapter) }

  let(:http_adapter) { double 'http_adapter' }

  describe '#download' do
    it 'writes downloaded body to specified file' do
      fake_body = "fake body\n"
      url = double 'url'

      expect(http_adapter).to receive(:get).with(url).and_return double('resp', body: fake_body)

      Dir.mktmpdir do |tmpdir|
        local_path = File.join(tmpdir, 'local')

        subject.download(url: url, local_path: local_path)

        expect(File.read(local_path)).to eq fake_body
      end
    end
  end
end
