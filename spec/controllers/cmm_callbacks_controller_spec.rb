require 'rails_helper'
require 'spec_helper'

RSpec.describe CmmCallbacksController, type: :controller do

  describe "POST create" do

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

    subject { post :create, valid_request, valid_session }

    it "adds a request when prompted from the callback" do
      expect(subject).to redirect_to(action: :show), id: 1
    end

    it "deletes a request when asked to do so" do
      expect(subject).to redirect_to(action: :show), id: 1
    end

  end

end
