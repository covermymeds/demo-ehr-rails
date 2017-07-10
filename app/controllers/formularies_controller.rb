class FormulariesController < ApplicationController

  def pa_required
    if params[:patient_id].nil? ||
       params[:drug_id].nil?    ||
       params[:drug_name].nil?

      head :no_content
    else
      patient = Patient.find(params[:patient_id])
      prescription = Prescription.new(drug_number: params[:drug_id],
                                      drug_name: params[:drug_name])
      pharmacy = params[:pharmacy_id].blank? ? Pharmacy.new : Pharmacy.find(params[:pharmacy_id])
      result = Formulary.pa_required?(patient, prescription, pharmacy)
      render json: result
    end
  end

end
