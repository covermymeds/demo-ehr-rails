module RequestPagesHelper

  def show_question(form_name, question, data)
    # uncomment the below lines to hide questions
    # that are either statements, not required, or already answered
    # form_name != "pa_request" ||
    #   ( question[:question_type] != "STATEMENT" &&
    #     question[:flag] == "REQUIRED" && 
    #     data[question[:question_id].underscore.to_sym].nil? ) ||
    #   is_patient_name(question)

    true
  end

  def is_patient_name(question)
    question["coded_reference"].present? &&
    question["coded_reference"]["code"] == "prior-auth-header"
  end

  def has_showable_questions(form_name, question_set, data)
    (question_set["questions"].count { |q| show_question(form_name, q, data) } ) > 0
  end

  def show_question_set(form_name, question_set, data)
    form_name != "pa_request" || 
    has_showable_questions(form_name, question_set, data)
  end

  def render_question(question, form_name, data)
    # render the correct question based on the type
    question_type = {
      FREE_TEXT: "free_text",
      FREE_AREA: "free_area",
      DATE: "date",
      STATEMENT: "statement",
      CHOICE: "choice",
      CHECKBOX: "checkbox",
      HIDDEN: "hidden",
      FILE: "file"
    }.fetch( question[:question_type].to_sym, :HIDDEN )
    question_type = :HIDDEN unless show_question(form_name, question, data)
    render partial: question_type.to_s.downcase, locals:{ question: question, form_name:form_name, data: data }
  end
  
  def display_if_not(display)
    "disabled" if display == "DISABLED"
  end

  def checked_if(checked)
    "checked" if checked != ""
  end

  def multiple_if(multiple)
    "multiple" if multiple == "true"
  end

  def multiple_checked_if(option, value)
    "checked" if value && value != "" && value.include?(option)
  end

  def selected_if(option, value)
    "selected" if option == value
  end

  def require_if(flag)
    "data-required required" if flag == "REQUIRED"
  end

  def validations_if(validations)
    if not validations.nil?
      ("data-validation='"+validations+"'").html_safe
    end
  end

  def render_coded_reference(ref)
    if(ref)
      referenceString = [ref[:qualifier], ref[:code], ref[:code_system_version]].join(":")
      ("data-coded-reference=" + referenceString).html_safe
    end
  end

  def render_validation(key, validations)
    if(key && validations)
      validation = validations[key.to_sym]
      case validation[:type]
      when "REGEX"
        ("data-pattern='" + validation[:value] + "'").html_safe
      when "MIME_TYPES"
        ("accept='"+ validation[:value].join(', ') + "'").html_safe
      when "BYTE_LIMIT"
        ("data-file-size='" + validation[:value].to_s + "'").html_safe
      end
    end
  end

  def massage(question_id, form_name)
    
    # some questions have a nil next-question-id, and depend on the default-next-question-id
    return "" if question_id.nil?

    if question_id =~ /\[\]/
      # if the question_id in question includes an array, we have to put the [] outside
      return form_name.to_s + "[" + question_id.sub('[]','') + "]" + "[]"
    else
      # otherwise, we just return the question_id scoped to the form
      return form_name.to_s + "[" + question_id + "]"
    end
  end

  def form_type(form)
    # loop through each question-set, looking for FILE elements
    has_file_questions = false
    form[:question_sets].each do |qs|
      has_file_questions ||= qs[:questions].any? {|q| q[:question_type] == "FILE" }
    end
    
    (has_file_questions) ? 'multipart/form-data' : 'application/x-www-form-urlencoded'
  end

end
