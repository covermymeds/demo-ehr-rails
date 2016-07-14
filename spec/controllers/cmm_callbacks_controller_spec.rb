require 'rails_helper'
require 'spec_helper'

RSpec.describe CmmCallbacksController, type: :controller do
  describe 'POST create' do
    fixtures :roles, :users
    let!(:patient) { Patient.create!(first_name:'Autopick', last_name:'Smith', date_of_birth:'10/01/1971', state:'OH')
}
    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # PatientsController. Be sure to keep this updated too.
    let(:valid_session) { { 'Content-Type' => 'application/json' } }

    let(:valid_request) do
      JSON.parse(File.read('spec/fixtures/valid_request.json'))
    end

    let(:delete_request) do
      JSON.parse(File.read('spec/fixtures/delete_request.json'))
    end

    context 'when a prescription exists' do
      before do
        Prescription.create!(drug_number: '085705', patient: patient)
        stub_request(:delete, "https://api.covermymeds.com/requests/tokens/?v=1").
         to_return(:status => 200, :body => "", :headers => {})
      end
      # in both of these tests (adds.. and deletes...) the controller redirects to show the
      # request that was created by the callback, or that was updated by the callback.
      it "adds a request when prompted from the callback" do
        post :create, valid_request, format: :json
        expect(response.status).to eq(200)
      end

      it "deletes a request when asked to do so" do
        post :create, delete_request, valid_session
        expect(response.status).to eq(200)
      end
    end

    context 'when the NPI is recognized' do
      junklet :first_name, :last_name
      let(:npi)         { valid_request['request']['prescriber']['npi'] }
      let(:request_id)  { valid_request['request']['id'] }
      let(:role)        { Role.doctor }
      let!(:user)       { User.find_by_npi(npi) }
      let(:do_request)  { post :create, valid_request, format: :json }
      let!(:prescription)    { Prescription.create! patient: patient, drug_number: '123456', quantity: 30, frequency: 'qD', refills: 2, dispense_as_written: true, drug_name: 'My Drug' }
      let!(:pa_request) { PaRequest.create!(cmm_id: request_id, cmm_token: 'foo', prescription: prescription) }

      context 'when a prescription exists' do
        before do
          Prescription.create!(drug_number: '085705', patient: patient)

          stub_request(:delete, "https://api.covermymeds.com/requests/tokens/foo?v=1").
            to_return(:status => 200, :body => "", :headers => {})
        end
        # in both of these tests (adds.. and deletes...) the controller redirects to show the
        # request that was created by the callback, or that was updated by the callback.
        it 'adds a request when prompted from the callback' do
          post :create, valid_request, format: :json
          expect(response.status).to eq(200)
        end

        it 'deletes a request when asked to do so' do
          post :create, delete_request, valid_session
          expect(response.status).to eq(200)
        end

        it 'updates a PaRequest and alerts the prescriber' do
          expect { do_request }.to change { user.reload.alerts.count }.from(0).to(1)
        end
      end

      context "when the EHR doesn't have the prescription" do

        it 'initiates PA for the new prescription' do
          post :create, valid_request, format: :json
          expect(response.status).to eq(200)
        end

        it 'alerts the prescriber' do
          expect { do_request }.to change { user.reload.alerts.count }.from(0).to(1)
        end

      end
    end

    context 'when the NPI is not recognized' do
      it 'responds with a 410' do
        post :create, valid_request.deep_merge('request' => { 'prescriber' => { 'npi' => 'unrecognized_npi' } }), format: :json
        expect(response.status).to eq(410)
      end
    end
  end
end
