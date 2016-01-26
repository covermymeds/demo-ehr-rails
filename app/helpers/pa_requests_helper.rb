module PaRequestsHelper
  
  LABEL_MAP = {
    not_needed:   "warning",
    unsent:       "warning",
    cancelled:    "danger",
    approved:     "success",
    denied:       "danger",
    favorable:    "success",
    unfavorable:  "danger"
  }

  def cmm_outcome_label(request)
    level = LABEL_MAP[request.outcome.downcase.underscore.parameterize.to_sym] || 'default'
    content_tag(:span, request.status, class: "label label-#{level}")
  end
end
