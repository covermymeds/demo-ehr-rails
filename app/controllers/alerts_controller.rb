class AlertsController < ApplicationController
  def index
    @alerts = current_user.alerts
  end

  def destroy
    @alert = Alert.find(params[:id])
    if @alert.destroy
      redirect_to alerts_path
    end
  end
end
