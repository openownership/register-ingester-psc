# frozen_string_literal: true

require 'json'
require 'register_ingester_psc/records_handler'

RSpec.describe RegisterIngesterPsc::RecordsHandler do
  subject do
    described_class.new(
      repository:,
      producer:,
      roe_repository:,
      roe_producer:
    )
  end

  let(:repository) { double 'repository' }
  let(:producer) { double 'producer' }
  let(:roe_repository) { double 'roe_repository' }
  let(:roe_producer) { double 'roe_producer' }

  describe '#handle_records' do
    let(:existing_record) { double 'existing_record', roe?: false, data: double(etag: 'etag1') }
    let(:existing_roe_record) { double 'existing_roe_record', roe?: true, data: double(etag: 'etag2') }
    let(:new_record) { double 'existing_record', roe?: false, data: double(etag: 'etag3') }
    let(:new_roe_record) { double 'existing_roe_record', roe?: true, data: double(etag: 'etag4') }

    # rubocop:disable RSpec/ExpectInHook
    before do
      expect(repository).to receive(:get).with(existing_record.data.etag).and_return true
      expect(roe_repository).to receive(:get).with(existing_roe_record.data.etag).and_return true
      expect(repository).to receive(:get).with(new_record.data.etag).and_return nil
      expect(roe_repository).to receive(:get).with(new_roe_record.data.etag).and_return nil
      allow(repository).to receive(:store)
      allow(roe_repository).to receive(:store)
      allow(producer).to receive(:produce)
      allow(roe_producer).to receive(:produce)
      allow(producer).to receive(:finalize)
      allow(roe_producer).to receive(:finalize)
    end
    # rubocop:enable RSpec/ExpectInHook

    it 'stores received records in repository' do
      subject.handle_records [existing_record, existing_roe_record, new_record, new_roe_record]

      expect(repository).to have_received(:store).with([new_record])
      expect(roe_repository).to have_received(:store).with([new_roe_record])
      expect(producer).to have_received(:produce).with([new_record])
      expect(roe_producer).to have_received(:produce).with([new_roe_record])
      expect(producer).to have_received(:finalize)
      expect(roe_producer).to have_received(:finalize)
    end
  end
end
