# frozen_string_literal: true

require_relative '../config/settings'

module RegisterIngesterPsc
  module Streams
    module Config
      PSC_STREAM_API_KEY = ENV.fetch('PSC_STREAM_API_KEY', nil)
    end
  end
end
