require 'uri'
require 'faraday'
require 'faraday_middleware'
# Add persistent http option

module RegisterIngesterPsc
  module Adapters
    class HttpAdapter
      HttpError = Class.new(StandardError)
      HttpResponse = Struct.new(:status, :headers, :body, :success)

      def get(url, params: {}, headers: {}, raise_on_failure: false)
        streamed = []
        current_chunk = ""

        response = Faraday.new.get(
          URI(url), params, headers
        ) do |req|
          req.options.on_data = Proc.new do |chunk, overall_received_bytes|
            current_chunk += chunk
            lines = current_chunk.split("\n")
            if current_chunk[-1] == "\n"
              lines[0...-1].each do |line|
                next if line.empty?
                yield line
              end
              current_chunk = ""
            elsif lines.length > 1
              lines[0...-1].each do |line|
                next if line.empty?
                yield line
              end
              current_chunk = lines[-1]
            end
            streamed << chunk
          end
        end

        raise HttpError if !response.success? && raise_on_failure

        HttpResponse.new(response.status, response.headers, streamed.join, response.success?)
      end
    end
  end
end
