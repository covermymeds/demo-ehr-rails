require 'rails_helper'
require 'spec_helper'

RSpec.describe CmmCallbacksController, type: :controller do

  describe "POST create" do
    fixtures :roles

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # PatientsController. Be sure to keep this updated too.
    let(:valid_session) {{'Content-Type'=>'application/json'}}

    let(:valid_request) do
      JSON.parse(File.read("spec/fixtures/valid_request.json"))
    end

    let(:delete_request) do
      JSON.parse(File.read("spec/fixtures/delete_request.json"))
    end

    context 'when a prescription exists' do
      before do
        Prescription.create!(drug_number: '085705')
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

    context "when the NPI is recognized" do
      junklet :first_name, :last_name
      let(:npi)        { valid_request['request']['prescriber']['npi'] }
      let(:request_id) { valid_request['request']['id'] }
      let(:role)       { Role.doctor }
      let!(:user)      { User.create!(npi: npi, first_name: first_name, last_name: last_name, role_id: role.id) }
      let(:do_request) { post :create, valid_request, format: :json }
      let!(:pa_request) { PaRequest.create!(cmm_id: request_id) }

      context 'when a prescription exists' do
        before do
          Prescription.create!(drug_number: '085705')
        end
        # in both of these tests (adds.. and deletes...) the controller redirects to show the
        # request that was created by the callback, or that was updated by the callback.
        it "adds a request when prompted from the callback" do
          post :create, valid_request, format: :json
          expect(response.status).to eq(302)
        end

        it "deletes a request when asked to do so" do
          post :create, delete_request, valid_session
          expect(response.status).to eq(302)
        end

        it "updates a PaRequest and alerts the prescriber" do
          expect{ do_request }.to change{ user.reload.alerts.count }.from(0).to(1)
        end
      end

      context "when the EHR doesn't have the prescription" do
        it "ignores the PA" do
          expect(PaRequest).to_not receive(:new)
          post :create, valid_request, format: :json
        end

        it "alerts the prescriber" do
          expect{ do_request }.to change{ user.reload.alerts.count }.from(0).to(1)
        end

        it "returns 404" do
          post :create, valid_request, format: :json
          expect(response.status).to eq(404)
        end
      end
    end

    context "when the NPI is not recognized" do
      it "responds with a 410" do
        post :create, valid_request, format: :json
        expect(response.status).to eq(410)
      end
    end
  end
end
