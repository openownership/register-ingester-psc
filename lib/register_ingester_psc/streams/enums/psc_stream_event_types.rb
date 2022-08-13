require 'register_ingester_psc/types'

module RegisterIngesterPsc
  module Streams
    PscStreamEventTypes = Types::String.enum(
      'changed',
      'deleted'
    )
  end
end
