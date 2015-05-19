require 'rails_helper'

describe FormulariesController, type: :controller do
  fixtures :patients
  junklet :drug_id, :drug_name
  let(:patient)   { patients('patient_Amber') }
  let(:valid_attributes) do
    {
      prescriptions: [
        { drug_id: drug_id, name: drug_name }
      ],
      patient_id: patient.id
    }
  end
  let(:indicator_result) do
    # result = Hashie::Mash.new(valid_attribues)
    # result.prescriptions.first.pa_required = true
    # result
    Hashie::Mash.new(valid_attributes).tap { |x| x.prescriptions.first.pa_required = true }
  end

  describe 'POST pa_required' do
    describe 'with valid params' do
      it 'returns a JSON object indicating if the client must start a PA for each prescription' do
        expect_any_instance_of(CoverMyMeds::Client).to receive(:post_indicators).and_return(indicator_result)
        post :pa_required, valid_attributes
        expected_response = { 'prescriptions' => [{ 'drug_id' => drug_id, 'name' => drug_name, 'pa_required' => true }] }
        expect(JSON.parse(response.body)).to include(expected_response)
      end
    end
  end
end
