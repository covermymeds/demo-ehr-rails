require 'rails_helper'

RSpec.describe "Prescriptions", type: :request do
  fixtures :all
  describe "GET /patient/1/prescriptions" do
    it "gets list of prescriptions for patients" do
      get patient_prescriptions_path(Patient.first)
      expect(response.status).to be(200)
    end
  end

end
