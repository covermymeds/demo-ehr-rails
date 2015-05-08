module WebmockStubs
  def stub_create_pa_request!
    response = JSON.parse(File.read('spec/fixtures/created_pa.json'))
    stub_request(:post, /https:\/\/(\S*):(\S*)@api.covermymeds.com\/requests\/\?v=1/ )
      .to_return(body: response.to_json)
  end
end

RSpec.configure do |c|
  c.include WebmockStubs
end
