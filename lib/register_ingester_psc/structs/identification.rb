module RegisterIngesterPsc
  class Identification < Dry::Struct
    attribute :country_registered, Types::String.optional.default(nil)
    attribute :legal_authority, Types::String
    attribute :legal_form, Types::String
    attribute :place_registered, Types::String.optional.default(nil)
    attribute :registration_number, Types::String.optional.default(nil)
  end
end
