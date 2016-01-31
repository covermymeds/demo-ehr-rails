class PaRequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :set_patient, only: [:create]
  before_action :set_prescription, only: [:create]

  # GET /requests
  # GET /requests.json
  def index
    # show all requests for this system
    @requests = PaRequest.for_display.order(updated_at: :desc)
    @tokens = @requests.pluck(:cmm_token)

    # update the request statuses
    begin
      unless @tokens.empty?
        update_local_data(CoverMyMeds.default_client.get_requests(@tokens))
      end
    rescue CoverMyMeds::Error::HTTPError => e
      logger.info "Exception getting requests: #{e.message}"
      flash_message("e.message: tokens = #{@tokens.to_s}", :error)
    end
  end

  # GET /patients/1/prescriptions/1/pa_requests/1
  def show
    respond_to do |format|
      format.html { redirect_to pa_display_page(@pa_request) }
    end
  end

  # GET /patients/1/prescriptions/1/pa_requests/new
  def new
    @pa_request = PaRequest.new 
  end

  # GET /patients/1/prescriptions/1/pa_requests/1/edit
  def edit
    # instance variables set by set_request already
    redirect_to { [@patient, @prescription, @pa_request] }
  end

  # POST /patients/1/prescriptions/1/pa_requests
  # POST /patients/1/prescriptions/1/pa_requests.json
  def create
    # create a prescription on the fly, if we need to
    if params[:prescription][:id].presence?
      @prescription = @patient.prescriptions.find(params[:prescription][:id])
    else
      @prescription = @patient.prescriptions.build(prescription_params)
    end

    # set the pharmacy in our PA request
    @prescription.pharmacy = Pharmacy.find(Pharmacy.first.id || pharmacy_params[:id])
    @prescription.date_prescribed = DateTime.now
    @prescription.pa_required = true

    # save the prescription, now we have all the information
    @prescription.save

    # create a pa request
    @pa_request = @prescription.pa_requests.build(pa_request_params)

    # create the request in the API
    response = CoverMyMeds.default_client.create_request  RequestConfigurator.new(@pa_request).request
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
    client = CoverMyMeds.default_client
    client.revoke_access_token? @pa_request.cmm_token
    @pa_request.remove_from_dashboard

    # delete the PA request from our database
    # we'll delete the PA request when the callback arrives
    flash_message('Request successfully removed from your dashboard.')

    respond_to do |format|
      format.html { redirect_to dashboard_path }
      format.json { head :no_content }
    end
  end

  private

  def pa_display_page pa_request
    if session[:use_custom_ui]
      pages_pa_request_path(@pa_request)
    else
      cmm_request_link_for(@pa_request)
    end
  end

  def update_local_data cmm_requests
    cmm_requests.each do |cmm_request|
      local = PaRequest.find_by_cmm_id(cmm_request['id'])
      unless local.nil? 
        # update workflow status & outcome
        local.update_attributes({
          cmm_workflow_status: cmm_request['workflow_status'],
          cmm_outcome: cmm_request['plan_outcome']})

        # update form selection
        if cmm_request['form_id']
          form = CoverMyMeds.default_client.get_form(
            cmm_request['form_id'])
          local.update_attributes({form_id: cmm_request['form_id'],
            form_name: form['description']})
        end
      end
    end
  end

  def set_request
    set_patient
    set_prescription
    @pa_request = @prescription.pa_requests.find(params[:id])
  end

  def set_prescription
    @prescription = @patient.prescriptions.find(params[:prescription_id]) || @patient.prescriptions.build
  end

  def set_patient
    binding.pry
    @patient = Patient.find(params[:patient_id]) || Patient.new
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pa_request_params
    params.require(:pa_request).permit(:patient_id, :prescription_id, :form_id, :prescriber_id, :urgent, :state, :sent, :cmm_token, :cmm_link, :cmm_id, :cmm_workflow_status, :cmm_outcome)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def prescription_params
    params.require(:prescription).permit(:drug_number, :quantity, :frequency, :refills, :dispense_as_written, :patient_id, :drug_name, :pharmacy_id)
  end

  def pharmacy_params
    params.require(:pharmacy).permit(:id)
  end

end
