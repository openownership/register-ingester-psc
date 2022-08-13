#!/usr/bin/env ruby

require 'register_ingester_psc/streams/clients/psc_stream'

stream_client = RegisterIngesterPsc::Streams::Clients::PscStream.new

stream_client.read_stream(timepoint: nil) do |record|
  print "RECEIVED RECORD: ", record, "\n"
end
