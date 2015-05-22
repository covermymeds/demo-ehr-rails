class FormulariesController < ApplicationController
  def pa_required
    if params[:prescriptions]
      client = ApiClientFactory.build
      patient = Patient.find(params[:patient_id])
      payer_hash = { bin: patient.bin, pcn: patient.pcn, group_id: patient.group_id }
      payer_hash.delete_if { |k, v| v.blank? }
      result = client.search_indicators(prescriptions: params[:prescriptions], patient: {}, payer: payer_hash)

      render json: result
    else
      error
    end
  end
end
