require 'rails_helper'
require 'spec_helper'

RSpec.describe CmmCallbacksController, type: :controller do

  describe "POST create" do

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

    # in both of these tests (adds.. and deletes...) the controller redirects to show the
    # request that was created by the callback, or that was updated by the callback.
    it "adds a request when prompted from the callback" do
      post :create, valid_request, format: :json
      expect(response.status).to eq(200)
    end

    it "deletes a request when asked to do so" do
      post :create, delete_request, valid_session
      expect(response.status).to eq(302)
    end

  end

end
