class FormulariesController < ApplicationController
  
  def pa_required
    if params[:prescriptions]
        patient = Patient.find(params[:patient_id])
        payer_hash = { bin: patient.bin, pcn: patient.pcn, group_id: patient.group_id }
        payer_hash.delete_if { |k, v| v.blank? }
        result = CoverMyMeds.default_client.search_indicators(prescriptions: params[:prescriptions], patient: {}, payer: payer_hash)
        result['prescriptions'].each do |prescription|
          prescription['pa_required'] = (prescription['pa_required'] || Prescription.check_pa_required?(prescription['name']))
          prescription['autostart'] = (prescription['autostart'] || Prescription.check_autostart?(prescription['name']))
        end
      render json: result
    else
      error
    end
  end
end
