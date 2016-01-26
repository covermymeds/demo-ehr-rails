class DrugsController < ApplicationController
  def index
    client = CoverMyMeds.default_client
    @drugs = client.drug_search(params[:term])
    render json: @drugs
  end
end
