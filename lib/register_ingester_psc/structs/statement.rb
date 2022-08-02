require 'register_ingester_psc/enums/restrictions_notices'
require 'register_ingester_psc/enums/statement_descriptions'
require 'register_ingester_psc/enums/statement_kinds'
require 'register_ingester_psc/structs/links'

module RegisterIngesterPsc
  class Statement < Dry::Struct
    attribute :ceased_on, Types::Nominal::Date.optional.default(nil)
    attribute :etag, Types::String
    attribute :kind, StatementKinds
    attribute :linked_psc_name, Types::String.optional.default(nil)
    attribute :links, Links
    attribute :notified_on, Types::Nominal::Date
    attribute :restrictions_notice_withdrawal_reason, RestrictionsNotices
    attribute :statement, StatementDescriptions
  end
end
