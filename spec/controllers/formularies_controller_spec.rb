require 'rails_helper'

describe FormulariesController, type: :controller do
  fixtures :patients
  junklet :drug_id, :drug_name
  let(:patient)   { patients('patient_Amber') }
  let(:patient_id) { patient.id }

  let(:request_data) do
    {
      drug_id: drug_id,
      drug_name: drug_name,
      patient_id: patient_id
    }
  end

  let(:indicator_result) do
    Hash 'indicator' => { 
      'prescription' => { 
        'drug_id' => drug_id, 
        'name' => drug_name, 
        'pa_required' => true, 
        'autostart' => false 
      } 
    } 
 end

  describe 'POST pa_required' do
    context 'when valid params are used' do
      it 'returns a JSON object indicating if the client must start a PA for each prescription' do
        expect_any_instance_of(CoverMyMeds::Client).to receive(:post_indicators)
          .and_return(Hashie::Mash.new(indicator_result))
        post :pa_required, request_data
        expect(JSON.parse(response.body)).to eq(indicator_result)
      end
    end

    context 'when drug_name is mising' do
      let(:drug_name) { nil }
      it 'returns no content' do
        post :pa_required, request_data
        expect(response.body).to eq('')
        expect(response.code).to eq('204')
      end
    end

    context 'when drug_id is mising' do
      let(:drug_id) { nil }
      it 'returns no content' do
        post :pa_required, request_data
        expect(response.body).to eq('')
        expect(response.code).to eq('204')
      end
    end

    context 'when patient_id is mising' do
      let(:patient_id) { nil }
      it 'returns no content' do
        post :pa_required, request_data
        expect(response.body).to eq('')
        expect(response.code).to eq('204')
      end
    end

  end
end
