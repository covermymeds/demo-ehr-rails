require 'rails_helper'

RSpec.describe PaRequestsController, type: :controller do
  let(:requests) {
    '{
      "requests": [
        {
          "memo": "system-specific information",
          "id": "PF6FK9",
          "api_id": "1vd9o4427lyi0ccb2uem",
          "form_id": "humana_boniva_iv_25297",
          "is_epa": false,
          "state": "OH",
          "thumbnail_urls": [
            "https://www.covermymeds.com/async/thumbnail/?request=PF6FK9&mode=plan"
          ],
          "pdf_url": "https://www.covermymeds.com/request/send/PF6FK9/",
          "html_url": "https://www.covermymeds.com/request/view/PF6FK9",
          "plan_outcome": "Favorable",
          "workflow_status": "Archived",
          "href": "https://api.covermymeds.com/requests/PF6FK9",
          "patient": {
            "first_name": "Susan",
            "last_name": "Denmark"
          },
          "prescriber": {
            "npi": null,
            "first_name": "",
            "last_name": ""
          },
          "prescription": {
            "name": "Boniva 2.5MG tablets"
          },
          "created_at": "2014-02-21T22:48:40Z",
          "tokens": [
            {
              "id": "gq9vmqai2mkwewv1y55x",
              "request_id": "PF6FK9",
              "href": "https://api.covermymeds.com/requests/tokens/gq9vmqai2mkwewv1y55x",
              "html_url": "https://www.covermymeds.com/request/view/PF6FK9?token_id=gq9vmqai2mkwewv1y55x",
              "pdf_url": "https://www.covermymeds.com/request/send/PF6FK9?token_id=gq9vmqai2mkwewv1y55x",
              "thumbnail_url": "https://www.covermymeds.com/async/thumbnail/?mode=plan&request=PF6FK9&token_id=gq9vmqai2mkwewv1y55x"
            }
          ]
        }
      ]
    }'
  }
  describe "GET 'index'" do
    it 'returns http success' do
      host = URI.parse(ENV['CMM_API_URL']).host
      api_id = ENV['CMM_API_KEY']
      api_secret = ENV['CMM_API_SECRET']
      authorization = Base64.encode64("#{api_id}:#{api_secret}")

      stub_request(:post, "https://#{host}/requests/search/?v=1")
        .with(headers: {
                'Authorization': 'Basic ' + authorization,
                'Content-Type': 'application/x-www-form-urlencoded',
                'Expect': '',
                'User-Agent': 'Faraday v0.10.0'
              })
        .to_return(status: 200, body: '', headers: {})

      get :index, status: 'all'

      expect(response).to be_success
    end
  end

end
