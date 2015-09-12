module PaRequestsHelper
  
  LABEL_MAP = {
    not_needed:   "warning",
    unsent:       "warning",
    cancelled:    "danger",
    request:      "info",
    response:     "warning",
    approved:     "success",
    denied:       "danger",
    request:      "info",
    response:     "warning"
  }

  def cmm_outcome_label(request)
    level = LABEL_MAP[request.status.downcase.underscore.parameterize.to_sym] || 'default'
    content_tag(:span, request.status, class: "label label-#{level}")
  end
end
