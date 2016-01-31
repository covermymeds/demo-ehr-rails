class PaRequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :set_prescription, only: [:new, :create]

  # GET /requests
  # GET /requests.json
  def index
    if params[:archived].present?
      @requests = PaRequest.archived.order(updated_at: :desc)
    else
      @requests = PaRequest.for_display.order(updated_at: :desc)
    end

    @tokens = @requests.for_display.pluck(:cmm_token)

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
    @pa_request = @prescription.pa_requests.new 
  end

  # GET /patients/1/prescriptions/1/pa_requests/1/edit
  def edit
    # instance variables set by set_request already
    redirect_to { [@patient, @prescription, @pa_request] }
  end

  # POST /patients/1/prescriptions/1/pa_requests
  # POST /patients/1/prescriptions/1/pa_requests.json
  def create
    # create a pa request
    @pa_request = @prescription.pa_requests.build(pa_request_params)

    # create the request in the API
    begin
      response = CoverMyMeds.default_client.create_request  RequestConfigurator.new(@pa_request).request
      flash_message "Your prior authorization request was successfully started."

      # stash away the token, id, link, and workflow status from the return
      @pa_request.set_cmm_values(response)
    
      respond_to do |format|
        if @pa_request.save
          format.html { redirect_to @patient }
        else
          format.html { render :new }
        end
      end

    rescue CoverMyMeds::Error::HTTPError => e
      flash_message "Error starting prior auth: #{e.message}", :error
      redirect_to :back
    end

  end

  # DELETE /pa_request/:pa_request_id/pa_requests/1
  def destroy
    # first, delete the PA request from our CMM dashboard
    @pa_request.remove_from_dashboard

    # delete the PA request from our database
    # we'll delete the PA request when the callback arrives
    flash_message('Request successfully removed.')

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  private

  def pa_display_page pa_request
    session[:use_custom_ui] ? 
      pages_pa_request_path(@pa_request) : 
      cmm_request_link_for(@pa_request)
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
    @patient = Patient.find(params[:patient_id])
    @prescription = @patient.prescriptions.find(params[:prescription_id])
    @pa_request = @prescription.pa_requests.find(params[:id])
  end

  def set_prescription
    @patient = Patient.find(params[:patient_id])
    @prescription = @patient.prescriptions.find(params[:prescription_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pa_request_params
    params.require(:pa_request).permit(:patient_id, :prescription_id, :form_id, :prescriber_id, :urgent, :state, :sent, :cmm_token, :cmm_link, :cmm_id, :cmm_workflow_status, :cmm_outcome)
  end

end
