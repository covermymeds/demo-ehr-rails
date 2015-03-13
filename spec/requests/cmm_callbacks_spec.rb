require 'rails_helper'

RSpec.describe "CmmCallbacks", :type => :request do
  describe "GET /cmm_callbacks" do
    it "works! (now write some real specs)" do
      get cmm_callbacks_path
      expect(response.status).to be(200)
    end
  end
end
