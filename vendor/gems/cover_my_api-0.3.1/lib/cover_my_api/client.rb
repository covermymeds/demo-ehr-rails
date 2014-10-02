require_relative 'api_request'
require_relative 'client/drugs'
require_relative 'client/forms'
require_relative 'client/requests'
require_relative 'client/tokens'
require_relative 'client/request_pages'

module CoverMyApi
  class Client
    include CoverMyApi::ApiRequest
    include CoverMyApi::Drugs
    include CoverMyApi::Forms
    include CoverMyApi::Requests
    include CoverMyApi::RequestPages
    include CoverMyApi::Tokens

    # use the block to set module privided instance variables:
    # ```ruby
    # Client.new('mark') do |client|
    #   client.requests_path = '/'
    #   client.requests_host = 'http://requests-api.dev'
    # end
    # ```
    #
    # Defaults are to proudction to make it easy for external gem consumers.
    def initialize(username, password=nil)
      @username = username
      @password = password
      yield(self) if block_given?
    end

    attr_writer :default_host
    def default_host
      @default_host ||= "https://api.covermymeds.com"
    end

  end
end

