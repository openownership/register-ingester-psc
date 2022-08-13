require 'register_ingester_psc/types'

module RegisterIngesterPsc
  module Streams
    PscStreamResourceKinds = Types::String.enum(
      'company-profile#company-profile',
      'filing-history#filing-history'
    )
  end
end
