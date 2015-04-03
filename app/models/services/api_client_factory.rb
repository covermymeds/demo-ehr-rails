class ApiClientFactory
  def self.build(use_integration: false)
    api_key = self.api_key(use_integration)
    api_secret = self.api_secret(use_integration)
    client = CoverMyApi::Client.new(api_key, api_secret)
    client.default_host = Rails.configuration.cmm_integration_url if use_integration
    client
  end

  def self.api_key(use_integration)
    use_integration ? Rails.application.secrets.integration_cmm_api_id : Rails.application.secrets.cmm_api_id
  end

  def self.api_secret(use_integration)
    use_integration ? Rails.application.secrets.integration_cmm_api_secret : Rails.application.secrets.cmm_api_secret
  end
end
