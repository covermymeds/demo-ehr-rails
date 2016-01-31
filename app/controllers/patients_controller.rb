class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  def index
    @patients = Patient.order(first_name: :asc).page(params[:page])
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render :show, status: :ok, location: @patient }
    end
  end

  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new patient_params

    respond_to do |format|
      if @patient.save
        flash_message 'Patient created successfully.'
        format.html { redirect_to patients_url }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /patients/1
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        flash_message 'Patient was successfully updated.'
        format.html { redirect_to patients_url }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    flash_message 'Patient record was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to patients_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find params[:id]
      @prescriptions = @patient.prescriptions.active
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(
        :first_name,
        :last_name,
        :date_of_birth,
        :street_1,
        :street_2,
        :city,
        :state,
        :zip,
        :phone_number,
        :email,
        :gender,
        :bin,
        :pcn,
        :group_id)
    end
  end
