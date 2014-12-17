require 'rails_helper'

RSpec.describe "Patients", type: :request do
  fixtures :all

  describe "GET /patients" do
    it "works! (now write some real specs)" do
      get patients_path
      expect(response.status).to be(200)
    end
  end

  describe "GET /patients/1" do
    it "shows patient info where appropriate" do

    @patient_no_prescription = Patient.where(first_name: 'Becky', last_name: 'Brown').first
      get patient_path(@patient_no_prescription)
      expect(response.status).to be(200)
    end

    it "shows prescription new page when no prescriptions yet" do
      @patient_with_prescriptions = Patient.where(first_name: 'Amber', last_name: 'Williams').first

      get patient_path(@patient_with_prescriptions)
      expect(response.status).to be(200)
    end
  end
end
