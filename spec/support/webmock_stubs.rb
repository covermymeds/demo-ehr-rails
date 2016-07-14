module WebmockStubs
  def stub_create_pa_request!
    response = JSON.parse(File.read('spec/fixtures/created_pa.json'))
    allow_any_instance_of(CoverMyMeds::Client).to receive(:create_request).and_return(Hashie::Mash.new(response))
  end

  def stub_drugs drug_name, body   
    base_api_url =  URI.parse(ENV['CMM_API_URL']).host
    base_api_scheme = URI.parse(ENV['CMM_API_URL']).scheme
    stub_request(:get, "#{base_api_scheme}://#{base_api_url}/drugs/?q=#{drug_name}&v=1").
      to_return(status: 200, body: body, headers: {})
  end
end

RSpec.configure do |c|
  c.include WebmockStubs
end
