module RegisterIngesterPsc
  class Links < Dry::Struct
    attribute :self, Types::String
    attribute :statement, Types::String.optional.default(nil)
  end
end
