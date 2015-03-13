require 'rails_helper'

RSpec.describe "Callbacks", :type => :request do
  describe "GET /callbacks" do
    it "works! (now write some real specs)" do
      get callbacks_path
      expect(response.status).to be(200)
    end
  end
end
