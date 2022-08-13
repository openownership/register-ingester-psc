#!/usr/bin/env ruby

require 'register_ingester_psc/streams/clients/psc_stream'

stream_client = RegisterIngesterPsc::Streams::Clients::PscStream.new

stream_client.read_stream(timepoint: 4178539) do |record|
  print "RECEIVED RECORD: ", record.to_h, "\n"
end
