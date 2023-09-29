# frozen_string_literal: true

require 'active_support'
require 'json'

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/time'
require 'active_support/core_ext/string/conversions'
require 'active_support/core_ext/object/json'

require_relative 'register_ingester_psc/version'

Time.zone = 'UTC'
ActiveSupport::JSON::Encoding.use_standard_json_time_format = true
ActiveSupport::JSON::Encoding.escape_html_entities_in_json = true

module RegisterIngesterPsc
  class Error < StandardError; end
end
