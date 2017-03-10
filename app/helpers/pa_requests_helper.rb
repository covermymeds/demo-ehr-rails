module PaRequestsHelper

  LABEL_MAP = {
    not_needed:   'warning',
    unsent:       'warning',
    cancelled:    'danger',
    approved:     'success',
    denied:       'danger',
    favorable:    'success',
    unfavorable:  'danger'
  }.freeze

  def cmm_outcome_label(request)
    level = LABEL_MAP[sanitize_status(request.outcome)] ||
            'default'
    content_tag(:span, request.status, class: "label label-#{level}")
  end

  def retrospective_label(request)
    return unless request.is_retrospective
    content_tag(:span, 'pharmacy', class: 'label label-info')
  end

  def sanitize_status(status)
    status.downcase.underscore.parameterize.to_sym
  end

end
