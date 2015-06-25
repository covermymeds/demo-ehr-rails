class FormulariesController < ApplicationController
  
  def pa_required
    if params[:prescriptions]
        client = CoverMyMeds.default_client
        patient = Patient.find(params[:patient_id])
        payer_hash = { bin: patient.bin, pcn: patient.pcn, group_id: patient.group_id }
        payer_hash.delete_if { |k, v| v.blank? }
        result = client.search_indicators(prescriptions: params[:prescriptions], patient: {}, payer: payer_hash)
        result['prescriptions'].each do |prescription|
          prescription['pa_required'] = (prescription['pa_required'] || Prescription.pa_required?(prescription['name']))
          prescription['autostart'] = (prescription['autostart'] || Prescription.autostart?(prescription['name']))
        end
      render json: result
    else
      error
    end
  end
end
