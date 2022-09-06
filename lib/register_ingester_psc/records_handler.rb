require 'register_ingester_psc/config/settings'
require 'register_sources_psc/config/elasticsearch'
require 'register_sources_psc/repositories/company_record_repository'
require 'register_ingester_psc/records_producer'

module RegisterIngesterPsc
  class RecordsHandler
    def initialize(repository: nil, producer: nil)
      @repository = repository || RegisterSourcesPsc::Repositories::CompanyRecordRepository.new(
        client: RegisterSourcesPsc::Config::ELASTICSEARCH_CLIENT)
      @producer = producer || RecordsProducer.new
    end

    def handle_records(records)
      new_records = records.reject { |record| repository.get(record.data.etag) }

      return if new_records.empty?

      producer.produce(new_records)
      producer.finalize

      repository.store(new_records)
    end

    private

    attr_reader :repository, :producer
  end
end
