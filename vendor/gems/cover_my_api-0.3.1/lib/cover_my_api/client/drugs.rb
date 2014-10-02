module CoverMyApi
  module Drugs
    include HostAndPath

    CURRENT_VERSION = 1

    def drug_search drug, version=CURRENT_VERSION
      params = {q: drug, v: version}
      data = drugs_request GET, params: params
      data['drugs'].map { |d| Hashie::Mash.new(d) }
    end

    def drug_ndc_search ndc, version=CURRENT_VERSION
      params = {v: version}
      data = drugs_request GET, params: params, path: "#{ndc}/"
      data['drugs'].map { |d| Hashie::Mash.new(d) }
    end
    
  end
end
