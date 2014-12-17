module RequestPagesHelper

  def render_question(question, form_name, data)
    # render the correct question based on the type
    types = {
      FREE_TEXT: "free_text",
      FREE_AREA: "free_area",
      DATE: "date",
      STATEMENT: "statement",
      CHOICE: "choice",
      CHECKBOX: "checkbox",
      HIDDEN: "hidden",
      FILE: "file"
    }
    question_type = question[:question_type].to_sym
    if types.has_key?(question_type)
      render partial: types[question_type], locals:{question: question, form_name:form_name, data: data}
    else
      render partial: "unknown", locals:{question: question, form_name:form_name, data: data}
    end
  end
  
  def display_if_not(display)
    "disabled" if display == "DISABLED"
  end

  def checked_if(checked)
    "checked" if checked != ""
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
