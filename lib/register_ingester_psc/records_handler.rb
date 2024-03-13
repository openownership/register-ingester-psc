# frozen_string_literal: true

require 'register_sources_psc/config/elasticsearch'
require 'register_sources_psc/repository'

require_relative 'config/settings'
require_relative 'records_producer'

module RegisterIngesterPsc
  class RecordsHandler
    def initialize(
      repository: nil,
      producer: nil,
      roe_repository: nil,
      roe_producer: nil
    )
      @repository = repository || RegisterSourcesPsc::Repository.new(
        client: RegisterSourcesPsc::Config::ELASTICSEARCH_CLIENT,
        index: RegisterSourcesPsc::Config::ELASTICSEARCH_INDEX_COMPANY
      )
      @producer = producer || RecordsProducer.new(stream_name: ENV.fetch('PSC_STREAM', nil))
      @roe_repository = roe_repository || RegisterSourcesPsc::Repository.new(
        client: RegisterSourcesPsc::Config::ELASTICSEARCH_CLIENT,
        index: RegisterSourcesPsc::Config::ELASTICSEARCH_INDEX_OVERSEAS
      )
      @roe_producer = roe_producer || RecordsProducer.new(stream_name: ENV.fetch('ROE_STREAM', nil))
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
