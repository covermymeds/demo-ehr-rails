require 'rails_helper'

RSpec.describe DrugsController, :type => :controller do

  let(:base_api_url) { URI.parse(ENV['CMM_API_URL']).host }
  let(:base_api_scheme) { URI.parse(ENV['CMM_API_URL']).scheme }

  let(:term) { 'spironolactone' }
  let(:spironolactone) {
    '{
    "drugs": [
      {
        "id": "030967",
        "gpi": "37500020000315",
        "sort_group": null,
        "sort_order": null,
        "name": "Spironolactone",
        "route_of_administration": "OR",
        "dosage_form": "TABS",
        "strength": "100",
        "strength_unit_of_measure": "MG",
        "dosage_form_name": "tablets",
        "full_name": "Spironolactone 100MG tablets",
        "href": "https://api.covermymeds.com/drugs/030967"
      }]
    }'
  }

  describe "GET index" do
    it "returns http success" do
      stub_request(:get, "#{base_api_scheme}://#{base_api_url}/drugs/?q=spironolactone&v=1").
           to_return(:status => 200, :body => spironolactone, :headers => {})

      get :index, term: term
      expect(response).to be_success
    end
  end

end
