require 'rails_helper'

describe FormulariesController, type: :controller do
  fixtures :patients
  junklet :drug_id, :drug_name
  let(:patient)   { patients('patient_Amber') }
  let(:request_data) do
    {
      prescriptions: [
        { drug_id: drug_id, name: drug_name }
      ],
      patient_id: patient.id
    }
  end
  let(:indicator_result) { Hash 'indicator' => { 'prescription' => { 'drug_id' => drug_id, 'name' => drug_name, 'pa_required' => true, 'autostart' => false } } }

  describe 'POST pa_required' do
    describe 'with valid params' do
      it 'returns a JSON object indicating if the client must start a PA for each prescription' do
        expect_any_instance_of(CoverMyMeds::Client).to receive(:post_indicators).and_return(Hashie::Mash.new(indicator_result))
        post :pa_required, request_data
        expect(JSON.parse(response.body)).to eq(indicator_result)
      end
    end
  end
end
