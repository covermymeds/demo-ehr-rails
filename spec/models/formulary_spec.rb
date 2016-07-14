require 'rails_helper'

describe Formulary do

  describe '.pa_required?' do
    let(:base_api_url) { URI.parse(ENV['CMM_API_URL']).host }
    let(:base_api_scheme) { URI.parse(ENV['CMM_API_URL']).scheme }

    let(:result) { described_class.pa_required?(patient, drug) }
    let(:drug_number) { junk(:int, size: 6, format: :string) }
    let(:drug_name) { junk }
    let(:ndc) { junk(:int, size: 11, format: :string) }
    let(:prescription_params) do
      {
        drug_number: drug_number,
        drug_name: drug_name
      }
    end
    let(:drug) { Prescription.new(prescription_params) }

    let(:patient_params) do 
      {
        first_name: junk,
        last_name: junk,
        date_of_birth: '10/01/1971',
        state: ['OH', 'IN', 'KY', 'MA', 'ME', 'WA'].sample,
        bin: '773836',
        pcn: 'MOCKPBM',
        group_id: 'ABC1'
      }
    end
    let(:patient) { Patient.new(patient_params) }
    let(:result_params) do
      {
        indicator: {
          prescription: {
            drug_id: drug_number,
            name: drug_name,
            autostart: false,
            pa_required: false,
            predicted: false,
          }
        }
      }
    end
    before(:each) do 
      stub_request(:post, "#{base_api_scheme}://#{base_api_url}/indicators/?v=1").
        to_return(status: 200, body: result_params.to_json, :headers => {})
    end

    context 'when the drug is chocolate flavored' do
      let(:drug_name) { 'Chocolate flavor' }

      it 'returns pa:true/autostart:true' do
        rx = result[:indicator][:prescription]
        expect(rx[:pa_required]).to eq(true)
        expect(rx[:autostart]).to eq(true)
      end
    end

    context 'when the drug is vanilla flavored' do
      let(:drug_name) { 'Vanilla flavor' }

      it 'returns pa:true/autostart:false' do
        rx = result[:indicator][:prescription]
          expect(rx[:pa_required]).to eq(true)
          expect(rx[:autostart]).to eq(false)
      end
    end

    context 'when the drug is an arbitrary drug' do
      it 'returns pa:false/autostart:false' do
        rx = result[:indicator][:prescription]
        expect(rx[:pa_required]).to eq(false)
        expect(rx[:autostart]).to eq(false)
      end        
    end

  end
end
