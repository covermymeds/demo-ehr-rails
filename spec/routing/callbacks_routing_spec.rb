require "rails_helper"

RSpec.describe CmmCallbacksController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/cmm_callbacks").to route_to("cmm_callbacks#index")
    end

    it "does not route to #new" do
      expect(:get => "/cmm_callbacks/new").not_to route_to("cmm_callbacks#new")
    end

    it "routes to #show" do
      expect(:get => "/cmm_callbacks/1").to route_to("cmm_callbacks#show", :id => "1")
    end

    it "does not route to #edit" do
      expect(:get => "/cmm_callbacks/1/edit").not_to route_to("cmm_callbacks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/cmm_callbacks").to route_to("cmm_callbacks#create")
    end

    it "does not route to #update" do
      expect(:put => "/cmm_callbacks/1").not_to route_to("cmm_callbacks#update", :id => "1")
    end

    it "does not route to #destroy" do
      expect(:delete => "/cmm_callbacks/1").not_to route_to("cmm_callbacks#destroy", :id => "1")
    end

  end
end
