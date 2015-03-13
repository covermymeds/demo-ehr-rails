require "rails_helper"

RSpec.describe CallbacksController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/callbacks").to route_to("callbacks#index")
    end

    it "routes to #new" do
      expect(:get => "/callbacks/new").to route_to("callbacks#new")
    end

    it "routes to #show" do
      expect(:get => "/callbacks/1").to route_to("callbacks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/callbacks/1/edit").to route_to("callbacks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/callbacks").to route_to("callbacks#create")
    end

    it "routes to #update" do
      expect(:put => "/callbacks/1").to route_to("callbacks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/callbacks/1").to route_to("callbacks#destroy", :id => "1")
    end

  end
end
