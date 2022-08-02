module RegisterIngesterPsc
  StatementDescriptions = Types::String.enum(
    'no-individual-or-entity-with-signficant-control', # "The company knows or has reasonable cause to believe that there is no registrable person or registrable relevant legal entity in relation to the company"
    'psc-exists-but-not-identified', # "The company knows or has reasonable cause to believe that there is a registrable person in relation to the company but it has not identified the registrable person"
    'psc-details-not-confirmed', # "The company has identified a registrable person in relation to the company but all the required particulars of that person have not been confirmed"
    'steps-to-find-psc-not-yet-completed', # "The company has not yet completed taking reasonable steps to find out if there is anyone who is a registrable person or a registrable relevant legal entity in relation to the company"
    'psc-contacted-but-no-response', # "The company has given a notice under section 790D of the Act which has not been complied with"
    'psc-has-failed-to-confirm-changed-details', # "{linked_psc_name} has failed to comply with a notice given by the company under section 790E of the Act"
    'restrictions-notice-issued-to-psc', # "The company has issued a restrictions notice under paragraph 1 of Schedule 1B to the Act"
    'no-individual-or-entity-with-signficant-control-partnership', # "The partnership knows or has reasonable cause to believe that there is no registrable person or registrable relevant legal entity in relation to the partnership"
    'psc-exists-but-not-identified-partnership', # "The partnership knows or has reasonable cause to believe that there is a registrable person in relation to the partnership but it has not identified the registrable person"
    'psc-details-not-confirmed-partnership', # "The partnership has identified a registrable person in relation to the partnership but all the required particulars of that person have not been confirmed"
    'steps-to-find-psc-not-yet-completed-partnership', # "The partnership has not yet completed taking reasonable steps to find out if there is anyone who is a registrable person or a registrable relevant legal entity in relation to the partnership"
    'psc-contacted-but-no-response-partnership', # "The partnership has given a notice under Regulation 10 of The Scottish Partnerships (Register of People with Significant Control) Regulations 2017 which has not been complied with"
    'psc-has-failed-to-confirm-changed-details-partnership', # "The partnership has given a notice under Regulation 11 of The Scottish Partnerships (Register of People with Significant Control) Regulations 2017 which has not been complied with"
    'restrictions-notice-issued-to-psc-partnership', # "The partnership has issued a restrictions notice under paragraph 1 of Schedule 2 to The Scottish Partnerships (Register of People with Significant Control) Regulations 2017"
    'all-beneficial-owners-identified', # "All beneficial owners have been identified and all required information can be provided"
    'no-beneficial-owner-identified', # "No beneficial owners have been identified"
    'at-least-one-beneficial-owner-unidentified', # "Some beneficial owners have been identified and all required information can be provided"
    'information-not-provided-for-at-least-one-beneficial-owner', # "All beneficial owners have been identified but only some required information can be provided"
    'at-least-one-beneficial-owner-unidentified-and-information-not-provided-for-at-least-one-beneficial-owner' # "Some beneficial owners have been identified and only some required information can be provided"    
  )
end
