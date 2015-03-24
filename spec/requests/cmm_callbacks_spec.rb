require 'rails_helper'

RSpec.describe "CmmCallbacks", :type => :request do
  fixtures :all

  describe "GET /cmm_callbacks/:id" do
    it "shows the callback" do
      @callback = CmmCallback.first
      get cmm_callback_path(@callback)
      expect(response.status).to be(200)
    end
  end

end
