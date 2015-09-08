class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_use_custom_ui
  before_action :set_demo_users
  include ApplicationHelper

  def salutation
    current_user ? current_user.display_name : "Sign in..."
  end
  helper_method :salutation

  def flash_message(text, type = :notice)
    flash[type] ||= []
    flash[type] << text
  end

  def set_use_custom_ui
    session[:use_custom_ui] = true unless session.has_key? :use_custom_ui
    @_use_custom_ui = session[:use_custom_ui]
  end

  def set_demo_users
    @demo_doctor = User.doctors.first
    @demo_staff = User.staff.first
  end

  def cmm_request_link_for(request)
    params = {
      remote_user: {
        display_name: current_user ? "#{current_user.first_name} #{current_user.last_name}" : 'James Kirk',
        phone_number: '614-555-1212',
        fax_number: '614-444-4444'
      }
    }

    # have to include remote_user information for when we bounce to CMM & do deletes
    if request.cmm_link
      # token_id is included in cmm_link
      request.cmm_link + "&#{params.to_query}"
    else
      "#{ENV['CMM_API_URL']}/requests/#{request.cmm_id}?v=1&token_id=#{request.cmm_token_id}&#{params.to_query}"
    end
  end

end
