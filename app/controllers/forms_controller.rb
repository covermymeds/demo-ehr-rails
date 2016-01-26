class FormsController < ApplicationController
  def index
    client = CoverMyMeds.default_client
    @forms = client.form_search(params[:term], params[:drug_id], params[:state])
    render json: @forms
  end
end
