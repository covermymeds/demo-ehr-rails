module Staff
  class PaRequestsController < ApplicationController
    before_action :set_patient, only: [:create]

    def new
      @pa_request = PaRequest.new 
      @prescription = Prescription.new
    end

    def create
      @prescription = @patient.prescriptions.create!(
        prescription_params.merge({
          date_prescribed: DateTime.now,
          pa_required: true,
          }))

      @pa_request = @prescription.pa_requests.build(pa_request_params)

      response = CoverMyMeds.default_client.create_request  RequestConfigurator.new(@pa_request).request
      flash_message "Your prior authorization request was successfully started."

      @pa_request.set_cmm_values(response)

      respond_to do |format|
        if @pa_request.save
          format.html { redirect_to @patient }
        else
          format.html { render :new }
        end
      end
    end

    def show
      @pa_request = PaRequest.find(params[:id])
    end

    private

    def patient_params
      params.require(:patient)
    end

    def set_patient
      @patient = Patient.find(patient_params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pa_request_params
      params.require(:pa_request)
            .permit(:prescriber_id,
                    :form_id, 
                    :urgent, 
                    :state)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prescription_params
      params.require(:prescription)
            .permit(:drug_number, 
                    :drug_name,
                    :quantity, 
                    :frequency, 
                    :refills, 
                    :dispense_as_written)
    end
  end
end
