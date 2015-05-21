class ApiClientFactory
  def self.build
    api_key = Rails.application.secrets.cmm_api_id
    api_secret = Rails.application.secrets.cmm_api_secret
    client = CoverMyMeds::Client.new(api_key, api_secret) do |client|
      client.default_host = ENV['CMM_API_URL']
    end
  end
end
