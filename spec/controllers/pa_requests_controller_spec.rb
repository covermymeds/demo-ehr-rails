require 'rails_helper'

RSpec.describe PaRequestsController, type: :controller do
  describe "GET 'index'" do
    it "returns http success" do
      stub_request(:post, "https://#{ENV['CMM_API_KEY']}:#{ENV['CMM_API_SECRET']}@#{URI.parse(ENV['CMM_API_URL']).host}/requests/search/?token_ids%5B%5D=&v=1")
               .with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'0', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'})
               .to_return(:status => 200, :body => "", :headers => {})      
      get 'index'
      
      expect(response).to be_success
    end
  end

end
