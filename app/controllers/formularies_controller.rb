class FormulariesController < ApplicationController
  def pa_required
    if params[:prescriptions]
      if params[:prescriptions][0][:name].downcase.include? "banana"
        result = {
          "prescriptions" => [{
            "pa_required" => true,
            "autostart"  => false
            }
          ]
        }
      else
        client = CoverMyMeds.default_client
        patient = Patient.find(params[:patient_id])
        payer_hash = { bin: patient.bin, pcn: patient.pcn, group_id: patient.group_id }
        payer_hash.delete_if { |k, v| v.blank? }
        result = client.search_indicators(prescriptions: params[:prescriptions], patient: {}, payer: payer_hash)
      end
      render json: result
    else
      error
    end
  end
end
