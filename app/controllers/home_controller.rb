class HomeController < ApplicationController
  def index
  end

  def home
    redirect_to patients_path and return if current_user && current_user.prescriber?
    redirect_to pa_requests_path and return if current_user && !current_user.prescriber?
    redirect_to root_url
  end

  def help

  end

  def toggle_custom_ui
    session[:use_custom_ui] = (not session[:use_custom_ui])
    redirect_to params[:return]
  end

  def reset_database
    DbResetter.reset 
    flash_message 'Database has been reset.'
    redirect_to root_url
  end
end
