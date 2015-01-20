module ApplicationHelper

  def current_user
    @current_user ||= User.find_by_id(session["user_id"])
    @current_user
  end

  def flash_class(key)
    case key
    when :notice then
      'alert alert-info'
    when :success then
      'alert alert-success'
    when :error then
      'alert alert-danger'
    when :alert then
      'alert alert-danger'
    end
  end

  def ehr_error_messages(flash)
    html = "<div class='row'>"
    flash.each do |key, value|
      Array(value).each do |message|
        html += <<-HTML
        <div class="#{flash_class(key.parameterize.underscore.to_sym)}" id="flash_#{key}">
          <button type='button' class='close' data-dismiss='alert'>&times;</button>
          #{message.strip}
        </div>
        HTML
      end
    end
    html += "</div>"
    html.html_safe
  end

  def cmm_request_link_for(request)
    params = {
      api_id: Rails.application.secrets.api_id,
      token_id: request.cmm_token,
      remote_user: {
        display_name: 'Johnny Rocket',
        phone_number: '614-555-1212'
      }
    }
    if request.cmm_link
      request.cmm_link
    else
      "https://api.covermymeds.com/requests/#{request.cmm_id}?v=1&#{params.to_query}"
    end
  end

  def pa_request_edit_link(request, title = "View")
    if @_use_custom_ui
      link_to title, pa_request_request_pages_path(request), id: 'edit_pa_request'
    else
      link_to title, patient_prescription_pa_request_path(request.prescription.patient, request.prescription, request), id: 'edit_pa_request'
    end
  end


end
