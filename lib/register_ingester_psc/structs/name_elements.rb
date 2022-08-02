module RegisterIngesterPsc
  class NameElements < Dry::Struct
    attribute :forename, Types::String.optional.default(nil)
    attribute :other_forenames, Types::String.optional.default(nil)
    attribute :surname, Types::String
    attribute :title, Types::String.optional.default(nil)
  end
end
