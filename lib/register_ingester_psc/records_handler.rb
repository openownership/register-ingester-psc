require 'register_ingester_psc/config/settings'
require 'register_sources_psc/config/elasticsearch'
require 'register_sources_psc/repositories/company_record_repository'
require 'register_sources_psc/repositories/registered_overseas_record_repository'
require 'register_ingester_psc/records_producer'

module RegisterIngesterPsc
  class RecordsHandler
    def initialize(
      repository: nil,
      producer: nil,
      roe_repository: nil,
      roe_producer: nil
    )
      @repository = repository || RegisterSourcesPsc::Repositories::CompanyRecordRepository.new(
        client: RegisterSourcesPsc::Config::ELASTICSEARCH_CLIENT)
      @producer = producer || RecordsProducer.new(stream_name: ENV['PSC_STREAM'])
      @roe_repository = roe_repository || RegisterSourcesPsc::Repositories::RegisteredOverseasRecordRepository.new(
        client: RegisterSourcesPsc::Config::ELASTICSEARCH_CLIENT)
      @roe_producer = roe_producer || RecordsProducer.new(stream_name: ENV['ROE_STREAM'])
    end

    def handle_records(records)
      company_records = records.reject(&:roe?)
      roe_records = records.filter(&:roe?)

      handle_company_records company_records
      handle_roe_records roe_records
    end

    private

    attr_reader :repository, :producer, :roe_repository, :roe_producer

    def handle_company_records(company_records)
      new_records = company_records.reject { |record| repository.get(record.data.etag) }

      return if new_records.empty?

      producer.produce(new_records)
      producer.finalize

      repository.store(new_records)
    end

    def handle_roe_records(roe_records)
      new_records = roe_records.reject { |record| roe_repository.get(record.data.etag) }

      return if new_records.empty?

      roe_producer.produce(new_records)
      roe_producer.finalize

      roe_repository.store(new_records)
    end
  end
end
