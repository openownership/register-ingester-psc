require 'register_common/adapters/s3_adapter'
require 'register_ingester_psc/config/settings'
require 'register_ingester_psc/adapters/http_adapter'

module RegisterIngesterPsc
  module Config
    module Adapters
      S3_ADAPTER = RegisterCommon::Adapters::S3Adapter.new(credentials: AWS_CREDENTIALS)
      HTTP_ADAPTER = RegisterIngesterPsc::Adapters::HttpAdapter.new
    end
  end
end
