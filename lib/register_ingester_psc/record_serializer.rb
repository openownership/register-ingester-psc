# frozen_string_literal: true

require 'json'

module RegisterIngesterPsc
  class RecordSerializer
    def serialize(record)
      record.to_h.to_json
    end
  end
end
