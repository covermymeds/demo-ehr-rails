module ApplicationHelper

  def pill_link_to(label, link_params, html_options = {})
    if request.fullpath == link_params
      html_options[:class] ||= ''
      html_options[:class] << ' active '
    end

    content_tag(:li, html_options) do
      link_to(label, link_params)
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session["user_id"])
    @current_user
  end

  def flash_class(key)
    return 'alert alert-info' if key == 'notice'
    return 'alert alert-success' if key == 'success'
    return 'alert alert-danger' if key == 'error' || key == 'alert'
  end

  def cmm_request_link_for(request)
    if request.cmm_link
      request.cmm_link
    else
      "#{ENV['CMM_API_URL']}/requests/#{request.cmm_id}?v=1" \
      "&#{default_link_params.to_query}"
    end
  end

  def default_link_params
    return {
      api_id: Rails.application.secrets.api_id,
      token_id: request.cmm_token,
      remote_user: {
        display_name: 'Johnny Rocket',
        phone_number: '614-555-1212'
      }
    }
  end

  def pa_request_edit_link(request, title = 'View')
    if @_use_custom_ui
      link_to title, pages_pa_request_path(request), id: 'edit_pa_request'
    else
      link_to title, patient_prescription_pa_request_path(
        request.prescription.patient,
        request.prescription, request
      ), id: 'edit_pa_request'
    end
  end

  def json_pp(json)
    JSON.pretty_generate(JSON.parse(json))
  end

  def pluralize_without_count(count, noun, text = nil)
    return if count.zero?
    count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
  end
end
