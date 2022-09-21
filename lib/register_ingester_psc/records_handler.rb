require 'register_ingester_psc/config/settings'
require 'register_sources_psc/config/elasticsearch'
require 'register_sources_psc/repositories/company_record_repository'
require 'register_ingester_psc/records_producer'

# test code for BODS mapping
require 'register_bods_v2/services/publisher'
require 'register_sources_psc/bods_mapping/record_processor'
require 'register_sources_oc/services/resolver_service'
require 'register_sources_psc/repositories/company_record_repository'

module RegisterIngesterPsc
  class RecordsHandler
    def initialize(repository: nil, producer: nil, bods_publisher: nil, entity_resolver: nil, bods_mapper: nil)
      @repository = repository || RegisterSourcesPsc::Repositories::CompanyRecordRepository.new(
        client: RegisterSourcesPsc::Config::ELASTICSEARCH_CLIENT)
      @producer = producer || RecordsProducer.new

      # Test code for BODS mapping
      @bods_publisher = bods_publisher || RegisterBodsV2::Services::Publisher.new
      @entity_resolver = entity_resolver || RegisterSourcesOc::Services::ResolverService.new
      @bods_mapper = bods_mapper || RegisterSourcesPsc::BodsMapping::RecordProcessor.new(
        entity_resolver: @entity_resolver,
        bods_publisher: @bods_publisher
      )
    end

    def handle_records(records)
      # print "HANDLING RECORDS: ", records, "\n"
      # new_records = records.reject { |record| repository.get(record.data.etag) }

      # return if new_records.empty?

      # producer.produce(new_records)
      # producer.finalize

      # repository.store(new_records)

      # test code for BODS mapping
      records.each do |psc_record|
        bods_mapper.process(psc_record)
      end
    end

    private

    attr_reader :repository, :producer, :bods_publisher, :entity_resolver, :bods_mapper
  end
end
