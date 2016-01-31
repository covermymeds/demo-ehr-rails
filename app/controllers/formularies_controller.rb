class FormulariesController < ApplicationController
  
  def pa_required
    if params[:patient_id].nil? || 
       params[:drug_id].nil?    || 
       params[:drug_name].nil?
    
      head :no_content 
    else
      result = Formulary.pa_required?(Patient.find(params[:patient_id]),
        Prescription.new(drug_number: params[:drug_id],
                         drug_name: params[:drug_name]))
      render json: result
    end
  end

end
