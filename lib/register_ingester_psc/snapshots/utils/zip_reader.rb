require 'zip'

module RegisterIngesterPsc
  module Snapshots
    module Utils
      class ZipReader
        InvalidZipError = Class.new(StandardError)

        def open_stream(stream)
          zip = Zip::File.open_buffer(stream)
          raise InvalidZipError if zip.count > 1

          zip.first.get_input_stream
        end
      end
    end
  end
end
