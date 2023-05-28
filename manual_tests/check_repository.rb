#!/usr/bin/env ruby

require 'register_ingester_psc/config/settings'

require 'register_sources_psc/config/elasticsearch'

require 'register_sources_psc/repositories/company_record_repository'
company_record_repository = RegisterSourcesPsc::Repositories::CompanyRecordRepository.new(
  client: RegisterSourcesPsc::Config::ELASTICSEARCH_CLIENT,
)

begin
  # eb80f74b963afeedcdb80720550381cecdb5c87f (stream)
  # 231a5a1071ef608f60a79a0fce2c3e21e29f00b9 (snapshots)
  record = company_record_repository.get("eb80f74b963afeedcdb80720550381cecdb5c87f")
  print record.to_h, "\n"
rescue StandardError => e
  print "ERRORED: #{e}\n"
end
