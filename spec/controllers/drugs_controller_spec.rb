require 'rails_helper'

RSpec.describe DrugsController, :type => :controller do

  let(:base_api_url) { URI.parse(ENV['CMM_API_URL']).host }
  let(:base_api_scheme) { URI.parse(ENV['CMM_API_URL']).scheme }

  let(:term) { 'spironolactone' }

  describe "GET index" do
    it "returns http success" do

      stub_request(:get, "#{base_api_scheme}://#{ENV['CMM_API_KEY']}:#{ENV['CMM_API_SECRET']}@#{base_api_url}/drugs/?q=#{term}&v=1").
           with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
           to_return(:status => 200, :body => "", :headers => {})

      get :index, term: term
      expect(response).to be_success
    end
  end

end
