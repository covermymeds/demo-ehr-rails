require "cover_my_api/version"
require_relative 'cover_my_api/meta'
require_relative 'cover_my_api/client'

module CoverMyApi

  GET    = 'get'.freeze
  POST   = 'post'.freeze
  PUT    = 'put'.freeze
  DELETE = 'delete'.freeze

  def self.version
    "CoverMyAPI version #{CoverMyAPI::VERSION}"
  end

end
