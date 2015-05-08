class FormulariesController < ApplicationController

  def pa_required
    if params[:prescriptions]
      # params[:prescriptions] = Formulary.pa_required?(params[:prescriptions])
      client = CoverMyMeds::Client.new(ENV['INTEGRATION_CMM_API_KEY'], ENV['INTEGRATION_CMM_API_SECRET'])
      client.default_host = ENV['CMM_API_URL']
      patient = Patient.find(params[:patient_id])
      result = client.post_indicators(params[:prescriptions], {}, {bin: patient.bin, pcn: patient.pcn, group_id: patient.group_id})

      render json: params
    else
      error
    end
  end

  # activemodel serialize later
  def serialize_patient(patient)
  end

end
