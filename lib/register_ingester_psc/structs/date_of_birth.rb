module RegisterIngesterPsc
  class DateOfBirth < Dry::Struct
    attribute :day, Types::Nominal::Integer.optional.default(nil)
    attribute :month, Types::Nominal::Integer
    attribute :year, Types::Nominal::Integer
  end
end
