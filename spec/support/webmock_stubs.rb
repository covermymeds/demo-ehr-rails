module WebmockStubs
  def stub_create_pa_request!
    response = JSON.parse(File.read('spec/fixtures/created_pa.json'))
    allow_any_instance_of(CoverMyMeds::Client).to receive(:create_request).and_return(Hashie::Mash.new(response))
  end
end

RSpec.configure do |c|
  c.include WebmockStubs
end
