module RegisterIngesterPsc
  RestrictionsNotices = Types::String.enum(
    'restrictions-notice-withdrawn-by-court-order',
    'restrictions-notice-withdrawn-by-company'
  )
end
