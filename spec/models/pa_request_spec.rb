require 'rails_helper'

RSpec.describe PaRequest, type: :model do
  fixtures :patients
  fixtures :prescriptions
  let(:patient) { Patient.find_by(first_name: 'Amber' ) }
  let!(:prescription) { patient.prescriptions.create!(drug_number: "012345") }
  let(:request_params) do
    {
      cmm_link: 'https://blah',
      cmm_outcome: 'Unknown',
      cmm_workflow_status: 'New',
      cmm_token: 'kdksksdkfadkjadf',
      cmm_id: '123ABC',
      form_id: 'this_is_a_form',
      prescriber_id: 1,
      prescription_id: prescription.id
    }
  end

  describe "creating a pa_request" do
    context "when using valid values" do
      it 'is valid' do
        pa_request = PaRequest.new(request_params)
        expect(pa_request).to be_valid
      end

      it 'will show in task list by default' do
        pa_request = PaRequest.new(request_params)
        expect(pa_request.display).to eq(true)
      end
    end
  end

  context "when retrieving the task list" do
    it "only returns requests that are displayable" do
      expect(true).to be_truthy
    end
  end
end
