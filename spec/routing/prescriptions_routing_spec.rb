require "rails_helper"

RSpec.describe PrescriptionsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/patients/1/prescriptions").to route_to("prescriptions#index", :patient_id=>'1')
    end

    it "routes to #new" do
      expect(:get => "/patients/1/prescriptions/new").to route_to("prescriptions#new", :patient_id=>'1')
    end

    it "routes to #show" do
      expect(:get => "/patients/1/prescriptions/1").to route_to("prescriptions#show", :id => "1", :patient_id=>'1')
    end

    it "routes to #edit" do
      expect(:get => "/patients/1/prescriptions/1/edit").to route_to("prescriptions#edit", :id => "1", :patient_id=>'1')
    end

    it "routes to #create" do
      expect(:post => "/patients/1/prescriptions").to route_to("prescriptions#create", :patient_id=>'1')
    end

    it "routes to #update" do
      expect(:put => "/patients/1/prescriptions/1").to route_to("prescriptions#update", :id => "1", :patient_id=>'1')
    end

    it "routes to #destroy" do
      expect(:delete => "/patients/1/prescriptions/1").to route_to("prescriptions#destroy", :id => "1", :patient_id=>'1')
    end

  end
end
