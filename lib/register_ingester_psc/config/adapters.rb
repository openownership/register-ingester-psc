require 'register_common/adapters/http_adapter'
require 'register_common/adapters/s3_adapter'
require 'register_ingester_psc/config/settings'

module RegisterIngesterPsc
  module Config
    module Adapters
      HTTP_ADAPTER = RegisterCommon::Adapters::HttpAdapter.new
      S3_ADAPTER = RegisterCommon::Adapters::S3Adapter.new(credentials: AWS_CREDENTIALS)
    end
  end
end
