require 'rails_helper'

describe RequestPagesController, type: :controller do
  let(:patient_attributes) do
    {
      first_name:     'Mark',
      last_name:      'Harris',
      date_of_birth:  '10/11/1971',
      state:          'OH'
    }
  end
  let(:patient) { Patient.create! patient_attributes }
  let(:pharmacy_attributes) do
    {
      name:           'CVS',
      street:        '123 Easy St.'
    }
  end
  let(:pharmacy) { Pharmacy.create! pharmacy_attributes }
  let(:prescription_attributes) do
    { active:               true,
      drug_number:          '98033',
      drug_name:            'Nexium',
      quantity:             10,
      frequency:            'qD',
      refills:              3,
      dispense_as_written:  true,
      patient_id:           patient.id,
      pharmacy_id:          pharmacy.id }
  end
  let(:prescription) { Prescription.create! prescription_attributes }
  let(:pa_request_attributes) do
    { prescription_id: prescription.id,
      prescriber_id: 1,
      form_id: '123',
      urgent: false,
      state: 'OH',
      sent: false,
      # warning, the token and id are 'magic' values -- must refer to a real PA
      cmm_token: 'ygbjmeji7pb7fapjvnvr',
      cmm_link: 'https://dashboard.covermymeds.com/requests/V2X6E3?token_id=ygbjmeji7pb7fapjvnvr',
      cmm_id: 'V2X6E3',
      cmm_workflow_status: 'New' }
  end
  let(:pa_request) { PaRequest.create! pa_request_attributes }

  describe 'GET index' do
    context 'when using format json' do
      let(:action_url) { 'http://api.cmm.com?token_id=etc' }
      let(:rp_json) do
        JSON.parse( {
          request_page: {
            actions: [
              {
                href:    action_url,
                ref:     'pa_request',
                method:  'PUT',
                title:   'Save'
              }
            ]
          }
        }.to_json )
      end
      let(:client_params) do
        {
          id:        pa_request.cmm_id,
          token_id:  pa_request.cmm_token
        }
      end
      let(:show_params) do
        {
          format:           'json',
          # patient_id:       patient.id,
          # prescription_id:  prescription.id,
          id:    pa_request.id
        }
      end
      let(:request_pages_response) do
        {
            forms: {},
            data: {},
            validations: {},
            actions: []
        }
      end

      before do
        expect_any_instance_of(CoverMyMeds::Client).to receive(:get_request_page).with(pa_request.cmm_id, pa_request.cmm_token).and_return(Hashie::Mash.new(request_pages_response))
      end

      it 'hides the actions from the browser' do
        get :index, show_params
        expect(subject.instance_variable_get(:@request_page_json)).to_not include(action_url)
      end
    end
  end
end
