class HomeController < ApplicationController
  def index

  end

  def help

  end

  def toggle_custom_ui
    session[:use_custom_ui] = (not session[:use_custom_ui])
    redirect_to params[:return]
  end
end
