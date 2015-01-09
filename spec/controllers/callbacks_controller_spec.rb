require 'rails_helper'

RSpec.describe CallbacksController, type: :controller do

  describe "POST handle" do

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # PatientsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    let(:valid_request) do
      JSON.parse(File.read("spec/fixtures/valid_request.json"))
    end

    let(:delete_request) do
      JSON.parse(File.read("spec/fixtures/delete_request.json"))
    end

    it "adds a request when prompted from the callback" do
      post :handle, valid_request, valid_session
      expect(response).to be_success
    end

    it "deletes a request when asked to do so" do
      post :handle, delete_request, valid_session
      expect(response).to be_success
    end

  end

end
