class FormulariesController < ApplicationController

  def pa_required
    if params[:prescriptions]
      params[:prescriptions] = Formulary.pa_required?(params[:prescriptions])
      render json: params
    else
      error
    end
  end

end
