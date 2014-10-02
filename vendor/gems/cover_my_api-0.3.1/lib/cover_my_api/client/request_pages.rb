module CoverMyApi
  module RequestPages
    include HostAndPath

    CURRENT_VERSION = 1

    def get_request_page id, token_id, version = CURRENT_VERSION
      params = { 'token_id' => token_id, v: version }
      data = request_pages_request GET, params: params, path: "#{id}/", auth_type: :bearer
      Hashie::Mash.new(data)
    end

  end
end
