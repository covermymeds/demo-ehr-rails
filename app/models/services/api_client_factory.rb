class ApiClientFactory
  def self.build(use_integration: false)
    api_key = self.api_key(use_integration)
    api_secret = self.api_secret(use_integration)
    client = CoverMyApi::Client.new(api_key, api_secret) do |client|
      client.default_host = ENV['CMM_API_URL']
    end
  end

  def self.api_key(use_integration)
    use_integration ? Rails.application.secrets.integration_cmm_api_id : Rails.application.secrets.cmm_api_id
  end

  def self.api_secret(use_integration)
    use_integration ? Rails.application.secrets.integration_cmm_api_secret : Rails.application.secrets.cmm_api_secret
  end
end
