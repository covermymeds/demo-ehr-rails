class PaRequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  # GET /requests
  # GET /requests.json
  def index
    # the @requests var holds all requests to be shown to the user
    # if the token parameter is nil, then we don't have access to the request
    @requests = PaRequest.where.not(cmm_token: nil).order(created_at: :desc)
    @tokens = @requests.pluck(:cmm_token)

    # update the request statuses
    @cmm_requests = CoverMyMeds.default_client.get_requests(@tokens)
    @cmm_requests.each do |cmm_request|
      local = @requests.find_by_cmm_id(cmm_request[:id])

      # update workflow status & outcome
      local.update_attributes({
        cmm_workflow_status: cmm_request[:workflow_status],
        cmm_outcome: cmm_request[:plan_outcome]})

      # update form selection
      # if cmm_request[:form_id] && cmm_request[:form_id] != ""
      #   form = CoverMyMeds.default_client.get_form(cmm_request[:form_id])
      #   if form
      #     local.update_attributes({form_id: cmm_request[:form_id],
      #       form_name: form[:description]})
      #   end
      # end

    end
  end

  # GET /patients/1/prescriptions/1/pa_requests/1
  # GET /patients/1/prescriptions/1/pa_requests/1.json
  def show
    if @_use_custom_ui
      respond_to do |format|
        format.html { redirect_to pa_request_request_pages_path(@pa_request) }
        format.json { render :show, status: :ok, location: @pa_request }
      end
    else
      respond_to do |format|
        format.html { redirect_to cmm_request_link_for(@pa_request) }
        format.json { render :show, status: :ok, location: @pa_request }
      end
    end
  end

  # GET /patients/1/prescriptions/1/pa_requests/new
  def new
    if params[:patient_id] && params[:prescription_id]
      @patient = Patient.find(params[:patient_id])
      @prescription = @patient.prescriptions.find(params[:prescription_id])
      @pa_request = @prescription.pa_requests.build
      @pharmacy = @prescription.pharmacy
    else
      @patient = Patient.new
      @prescription = @patient.prescriptions.build
      @pa_request = @prescription.pa_requests.build
      @pharmacy = @prescription.pharmacy
    end
    @pa_request.state = @patient.state
    @pa_request.prescription.quantity = 30
  end

  # GET /patients/1/prescriptions/1/pa_requests/1/edit
  def edit
    # instance variables set by set_request already
    redirect_to { [@patient, @prescription, @pa_request] }
  end

  # POST /patients/1/prescriptions/1/pa_requests
  # POST /patients/1/prescriptions/1/pa_requests.json
  def create
    # find the patient we're making a request for
    @patient = Patient.find(params[:patient][:id])

    # create a prescription on the fly, if we need to
    if params[:prescription][:id] != ""
      @prescription = @patient.prescriptions.find(params[:prescription][:id])
    else
      @prescription = @patient.prescriptions.build(prescription_params)
    end

    # set the pharmacy in our PA request
    pharmacy_id = (params[:pharmacy][:id] == "") ? Pharmacy.first.id : params[:pharmacy][:id]
    @pharmacy = Pharmacy.find(pharmacy_id)
    @prescription.pharmacy = @pharmacy

    @prescription.date_prescribed = DateTime.now

    # save the prescription, now we have all the information
    @prescription.save

    # create a pa request
    @pa_request = @prescription.pa_requests.build(pa_request_params)

    # call out to the request pages API to create a request with CMM, given
    # the information we have about the patient and prescription
    new_request = RequestConfigurator.request(@prescription,
                                              @pa_request.form_id,
                                              User.find(params[:pa_request][:prescriber_id]))

    # create the request in the API
    # in your application, you will likely do this asynchronously, but
    # we are doing this inline for brevity
    response = RequestConfigurator.api_client().create_request new_request
    flash_message "Your prior authorization request was successfully started."

    # stash away the token, id, link, and workflow status from the return
    @pa_request.set_cmm_values(response)

    respond_to do |format|
      if @pa_request.save
        format.html { redirect_to @patient }
        format.json { render :show, status: :created, location: @prescription }
      else
        format.html { render :new }
        format.json { render json: @prescription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pa_request/:pa_request_id/pa_requests/1
  # DELETE /pa_request/:pa_request_id/pa_requests/1.json
  def destroy
    # first, delete the PA request from our CMM dashboard
    client = RequestConfigurator.api_client()
    client.revoke_access_token? @pa_request.cmm_token
    @pa_request.update_attributes(cmm_token: nil)

    # delete the PA request from our database
    # we'll delete the PA request when the callback arrives
    flash_message('Request successfully removed from your dashboard.')

    respond_to do |format|
      format.html { redirect_to dashboard_path   }
      format.json { head :no_content }
    end
  end

  private

  def set_request
    if params[:patient_id]
      # sometimes we send the patient & prescription information
      @patient = Patient.find(params[:patient_id])
      @prescription = @patient.prescriptions.find(params[:prescription_id])
      @pa_request = @prescription.pa_requests.find(params[:id])
    else
      # sometimes we just show the request from ID alone
      @pa_request = PaRequest.find(params[:id])
      @prescription = @pa_request.prescription
      @patient = @pa_request.prescription.patient
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pa_request_params
    params.require(:pa_request).permit(:patient_id, :prescription_id, :form_id, :prescriber_id, :urgent, :state, :sent, :cmm_token, :cmm_link, :cmm_id, :cmm_workflow_status, :cmm_outcome)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def prescription_params
    params.require(:prescription).permit(:drug_number, :quantity, :frequency, :refills, :dispense_as_written, :patient_id, :drug_name, :pharmacy_id)
  end

end
