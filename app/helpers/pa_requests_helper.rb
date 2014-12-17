module PaRequestsHelper
  
  def cmm_outcome_label(outcome)
    lookup = {
      favorable: "success",
      unfavorable: "warning"
    }
    level = lookup[outcome.downcase.to_sym] || 'default'
    content_tag(:span, outcome, class: "label label-#{level}")
  end
end
