class FormulariesController < ApplicationController
  
  def pa_required
    patient = Patient.find(params[:patient_id])

    result = CoverMyMeds.default_client.post_indicators(
      prescription: { drug_id: params[:drug_id], name: params[:drug_name] }, 
      patient: patient.to_patient_hash, 
      payer: patient.to_payer_hash)

    # for purposes of demonstration, vanilla flavors require PA
    # while chocolate flavors are auto-started and require Patient
    rx = result['indicator']['prescription']
    drug_name = rx['name'].downcase
    rx['pa_required'] ||= (drug_name.include?("vanilla") || drug_name.include?("chocolate"))
    rx['autostart'] ||= drug_name.include?("chocolate")

    render json: result
  end

private


end
