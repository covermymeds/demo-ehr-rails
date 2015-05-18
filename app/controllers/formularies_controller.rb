class FormulariesController < ApplicationController

  def pa_required
    if params[:prescriptions]
      client = CoverMyMeds::Client.new(ENV['CMM_API_KEY'], ENV['CMM_API_SECRET']) do |config|
        config.default_host = ENV['CMM_API_URL']
      end
      patient = Patient.find(params[:patient_id])
      result = client.search_indicators(prescriptions: params[:prescriptions], patient: {}, payer: {bin: patient.bin, pcn: patient.pcn, group_id: patient.group_id})

      render json: result
    else
      error
    end
  end

  # activemodel serialize later
  def serialize_patient(patient)
  end

end
