module RequestPagesHelper

  QUESTION_TYPES = {
    FREE_TEXT: 'free_text',
    FREE_AREA: 'free_area',
    DATE:      'date',
    STATEMENT: 'statement',
    CHOICE:    'choice',
    CHECKBOX:  'checkbox',
    HIDDEN:    'hidden',
    FILE:      'file'
  }.freeze

  def show_question(form_name, question, data)
    # uncomment the below lines to hide questions
    # that are either statements, not required, or already answered
    # form_name != 'pa_request' ||
    #   ( question[:question_type] != 'STATEMENT' &&
    #     question[:flag] == 'REQUIRED' && 
    #     data[question[:question_id].underscore.to_sym].nil? ) ||
    #   patient_name?(question)

    true
  end

  def patient_name?(question)
    question['coded_reference'].present? &&
      question['coded_reference']['code'] == 'prior-auth-header'
  end

  def showable_questions?(form_name, question_set, data)
    question_set['questions']
      .count { |q| show_question(form_name, q, data) } > 0
  end

  def show_question_set(form_name, question_set, data)
    form_name != 'pa_request' ||
      showable_questions?(form_name, question_set, data)
  end

  def render_question(question, form_name, data)
    # render the correct question based on the type
    question_type = QUESTION_TYPES
                    .fetch(question[:question_type].to_sym, :HIDDEN)
    question_type = :HIDDEN unless show_question(form_name, question, data)
    render partial: question_type.to_s.downcase,
           locals: { question: question, form_name:form_name, data: data }
  end

  def display_if_not(display)
    'disabled' if display == 'DISABLED'
  end

  def checked_if(checked)
    'checked' if checked != ''
  end

  def multiple_if(multiple)
    'multiple' if multiple == 'true'
  end

  def multiple_checked_if(option, value)
    'checked' if value.present? && value.include?(option)
  end

  def selected_if(option, value)
    'selected' if option == value
  end

  def require_if(flag)
    'data-required required' if flag == 'REQUIRED'
  end

  def validations_if(validations)
    return if validations.nil?
    ("data-validation='" + validations + "'").html_safe
  end

  def render_coded_reference(ref)
    return unless ref
    reference_string = [ref[:qualifier], ref[:code], ref[:code_system_version]]
      .join(':')
    ('data-coded-reference=' + reference_string).html_safe
  end

  def render_validation(key, validations)
    return unless key && validations
    validation = validations[key.to_sym]
    case validation[:type]
    when 'REGEX'
      ("data-pattern='" + validation[:value] + "'").html_safe
    when 'MIME_TYPES'
      ("accept='" + validation[:value].join(', ') + "'").html_safe
    when 'BYTE_LIMIT'
      ("data-file-size='" + validation[:value].to_s + "'").html_safe
    end
  end

  def massage(question_id, form_name)
    # some questions have a nil next-question-id, and depend on the default-next-question-id
    return '' if question_id.nil?
    # if the question_id is 'normal' we just return the question_id scoped to the form
    return form_name.to_s + '[' + question_id + ']' unless question_id =~ /\[\]/
    # if the question_id in question includes an array, we have to put the [] outside
    return form_name.to_s + '[' + question_id.sub('[]','') + ']' + '[]' if question_id =~ /\[\]/
  end

  def file_question?(qsets)
    # returns true if the question set has any file questions
    qsets.any? do |qs|
      qs[:questions].any? { |q| q[:question_type] == 'FILE' }
    end
  end

  def form_type(form)
    # loop through each question-set, looking for FILE elements
    return 'multipart/form-data' if file_question?(form[:question_sets])
    'application/x-www-form-urlencoded'
  end

end
