module PaRequestsHelper

  def request_tokens
    PaRequest.select('cmm_token').inject([]) {|acc,n| acc.push("'#{n.cmm_token}'")}
  end
  
  def cmm_outcome_label(outcome)
    lookup = {
      :favorable => "success",
      :unfavorable => "warning"
    }
    level = lookup[outcome.downcase.to_sym] || 'default'
    content_tag(:span, outcome, :class => "label label-#{level}")
  end
end
