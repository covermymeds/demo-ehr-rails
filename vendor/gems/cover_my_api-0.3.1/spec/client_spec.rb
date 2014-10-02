require 'spec_helper'

module CoverMyApi::ExampleApiResources
  include CoverMyApi::HostAndPath
  CURRENT_VERSION = 'current-version-1'
end

class CoverMyApi::Client
  include CoverMyApi::ExampleApiResources
end

describe CoverMyApi::Client do
  let(:username) { "any_api_id" }

  describe "#new" do

    context "configuring with a block" do
      it "sets the host and path for the resource" do
        client = CoverMyApi::Client.new(username) do |c|
          c.exampleapiresources_path = "/example/resouce/path/"
          c.exampleapiresources_host = "https://www.example-resource.com"
        end

        expect(client.exampleapiresources_path).to eq("/example/resouce/path/")
        expect(client.exampleapiresources_host).to eq("https://www.example-resource.com")
      end

      it "sets the default host" do
        client = CoverMyApi::Client.new(username) do |c|
          c.default_host = "www.example.com"
        end

        expect(client.default_host).to eq("www.example.com")
      end
    end

    context "NOT configuring with a block" do
      it "uses the default host and path for resources" do
        client = CoverMyApi::Client.new(username)

        expect(client.exampleapiresources_path).to eq("/exampleapiresources/")
        expect(client.exampleapiresources_host).to eq("https://api.covermymeds.com")
      end
    end

  end

  specify "#default_host" do
    client = CoverMyApi::Client.new(username)
    expect(client.default_host).to eq("https://api.covermymeds.com")
  end
end
