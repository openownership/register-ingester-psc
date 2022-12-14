require 'register_sources_psc/structs/company_record'

module RegisterIngesterPsc
  module Snapshots
    module Services
      class SnapshotRowProcessor
        def process_row(row)
          row = row.transform_values { |v| (v == '') ? nil : v }
          row = row.transform_keys(&:to_sym)
  
          RegisterSourcesPsc::CompanyRecord[row]
        end
      end
    end
  end
end
