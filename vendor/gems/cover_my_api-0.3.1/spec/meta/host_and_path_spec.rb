module CoverMyApi::ExampleApiResources
  include CoverMyApi::HostAndPath
end

class AnyClass
  include CoverMyApi::ExampleApiResources
  def default_host
    "http://default-host.com"
  end
end

describe AnyClass do

  describe "the added path setter" do
    its(:methods) { should include(:exampleapiresources_path=) }
    it "changes the exampleapiresources_path" do
      subject.exampleapiresources_path = "mypath"
      expect(subject.exampleapiresources_path).to eq("mypath")
    end
  end

  describe "the added path getter" do
    its(:methods) { should include(:exampleapiresources_path) }
    its(:exampleapiresources_path) { should eq("/exampleapiresources/") }
  end

  describe "the added host setter" do
    its(:methods) { should include(:exampleapiresources_host=) }
    it "changes the exampleapiresources_host" do
      subject.exampleapiresources_host = "myhost"
      expect(subject.exampleapiresources_host).to eq("myhost")
    end
  end

  describe "the added host getter" do
    its(:methods) { should include(:exampleapiresources_host) }
    its(:exampleapiresources_host) { should eq("http://default-host.com") }
  end

  describe "the added resouce-partially-applied method for web requests" do
    its(:methods) { should include(:exampleapiresources_request) }
    it "should proxy for #request" do
      expect(subject).to receive(:request).with(:GET, "http://default-host.com", "/exampleapiresources/", {v: 1})
      subject.exampleapiresources_request(:GET, params: {v: 1})
    end
  end

end
