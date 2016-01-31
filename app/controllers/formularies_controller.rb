class FormulariesController < ApplicationController
  
  def pa_required
    patient = Patient.find(params[:patient_id])
    prescription = Prescription.new(drug_number: params[:drug_id],
                                    drug_name: params[:drug_name])
    result = Formulary.pa_required?(patient, prescription)

    render json: result
  end

end
