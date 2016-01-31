class PrescriptionsController < ApplicationController

  before_action :set_prescription, only: [:show, :edit, :update, :destroy]
  before_action :doctors_only, only: [:new, :create]

  # GET /prescriptions
  # GET /prescriptions.json
  def index
    @patient = Patient.find(params[:patient_id])
    @prescriptions = @patient.prescriptions.active
  end

  # GET /prescriptions/1
  # GET /prescriptions/1.json
  def show
  end

  # GET /patient/:patient_id/prescriptions/new
  def new
    @patient = Patient.find(params[:patient_id])
    @prescription = @patient.prescriptions.build
  end

  # GET /patient/:patient_id/prescriptions/1/edit
  def edit
  end

  # POST /patient/:patient_id/prescriptions
  # POST /patient/:patient_id/prescriptions.json
  def create
    @patient = Patient.find(params[:patient_id])
    @prescription = @patient.prescriptions.build(
      prescription_params.merge({
        date_prescribed: Time.zone.now, 
        active: true}))
    
    respond_to do |format|
      if @prescription.save
        if @prescription.pa_required
          start_pa(@prescription)
        end
        flash_message('Prescription successfully created')
        format.html { redirect_to @patient }
        format.json { render :show, status: :created, location: @prescription }
      else
        format.html { render :new }
        format.json { render json: @prescription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patient/:patient_id/prescriptions/1
  # PATCH/PUT /patient/:patient_id/prescriptions/1.json
  def update
    respond_to do |format|
      if @prescription.update(prescription_params)
        if @prescription.pa_required && @prescription.pa_requests.for_display.empty?
          start_pa(@prescription)
        end
        flash_message('Prescription successfully updated.')
        format.html { redirect_to @patient }
        format.json { render :show, status: :ok, location: @prescription }
      else
        format.html { render :edit }
        format.json { render json: @prescription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patient/:patient_id/prescriptions/1
  # DELETE /patient/:patient_id/prescriptions/1.json
  def destroy
    # first, delete the PA request from our CMM dashboard
    client = CoverMyMeds.default_client
    @prescription.pa_requests.each do |pa_request|
      # delete the PA request's token from our access list
      if client.revoke_access_token? pa_request.cmm_token
        flash_message("Request #{pa_request.cmm_id} removed from your dashboard.")

        # delete the prescription, this deletes the pa_request too
        # we'll delete the PA request in the callback
      else
        flash_message("Unable to remove request #{pa_request.cmm_id} from your dashboard")
      end
    end

    @prescription.destroy
    flash_message('Prescription successfully removed from your dashboard.')

    respond_to do |format|
      format.html { redirect_to @patient }
      format.json { head :no_content }
    end
  end

  private
    def start_pa(prescription)
      # call out to the request pages API to create a request, given
      # the information we have about the patient and prescription
      pa_request = prescription.pa_requests.build(
        user: current_user,
        state: @patient.state,
        urgent: false)

      # create the request in the API
      # in your application, you will likely do this asynchronously, but
      # we are doing this inline for brevity
      response = CoverMyMeds.default_client.create_request RequestConfigurator.new(pa_request).request
      flash_message("Your prior authorization request was successfully started.")

      # stash away the token, id, link, and workflow status from the return
      pa_request.set_cmm_values(response)
      pa_request.save!
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_prescription
      @patient = Patient.find(params[:patient_id])
      @prescription = Prescription.find(params[:id])
    end

    def doctors_only
      unless current_user.role == Role.doctor
        flash_message('Only doctors may create new prescriptions.')
        redirect_to Patient.find(params[:patient_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prescription_params
      params.require(:prescription).permit(:drug_number, :quantity, :frequency, :refills, :dispense_as_written, :patient_id, :drug_name, :pharmacy_id, :pa_required, :autostart)
    end
  end
