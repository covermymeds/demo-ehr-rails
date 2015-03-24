class CmmCallback < ActiveRecord::Base
  belongs_to :pa_request, inverse_of: :cmm_callbacks
end
