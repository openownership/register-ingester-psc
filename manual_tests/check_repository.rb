#!/usr/bin/env ruby

require 'register_ingester_psc/config/settings'

require 'register_sources_psc/config/elasticsearch'

require 'register_sources_psc/repositories/company_record_repository'
company_record_repository = RegisterSourcesPsc::Repositories::CompanyRecordRepository.new(
  client: RegisterSourcesPsc::Config::ELASTICSEARCH_CLIENT
)


begin
  print company_record_repository.get("490436fdb0b238c5e91d616d3fa3d54ca6b898ec"), "\n"
rescue => e
  print "ERRORED: #{e}\n"
end
