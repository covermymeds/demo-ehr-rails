class PrescriptionsController < ApplicationController

  before_action :set_prescription, only: [:show, :edit, :update, :destroy]
  before_action :set_patient, only: [:index, :new, :create]
  before_action :doctors_only, only: [:new, :create]

  # GET /prescriptions
  # GET /prescriptions.json
  def index
    @prescriptions = @patient.prescriptions.active
  end

  # GET /prescriptions/1
  # GET /prescriptions/1.json
  def show
  end

  # GET /patient/:patient_id/prescriptions/new
  def new
    @prescription = @patient.prescriptions.build
  end

  # GET /patient/:patient_id/prescriptions/1/edit
  def edit
  end

  # POST /patient/:patient_id/prescriptions
  # POST /patient/:patient_id/prescriptions.json
  def create
    @prescription = @patient.prescriptions.build(
      prescription_params.merge(
        date_prescribed: Time.zone.now,
        active: true
      )
    )

    respond_to do |format|
      if @prescription.save
        flash_message('Prescription successfully created')
        if params[:start_pa] == '1'
          if @prescription.initiate_pa(current_user)
            flash_message('Your prior authorization request was successfully started.')
          end
        end
        format.html { redirect_to @patient }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /patient/:patient_id/prescriptions/1
  def update
    respond_to do |format|
      if @prescription.update(prescription_params)
        flash_message('Prescription successfully updated.')
        if params[:start_pa] && @prescription.initiate_pa(current_user)
          flash_message('Your prior authorization request was successfully started.')
        end
        format.html { redirect_to @patient }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /patient/:patient_id/prescriptions/1
  def destroy
    # first, delete the PA request from our CMM dashboard
    @prescription.pa_requests.each do |pa_request|
      pa_request.remove_from_dashboard
      flash_message("Request #{pa_request.cmm_id} removed from your dashboard.")
    end

    @prescription.destroy
    flash_message('Prescription successfully removed from your dashboard.')

    respond_to do |format|
      format.html { redirect_to @patient }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_prescription
      @patient = Patient.find(params[:patient_id])
      @prescription = Prescription.find(params[:id])
    end

    def set_patient
      @patient = Patient.find(params[:patient_id])
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
