class CmmCallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:create]

  before_action :set_callback, only: [:show]

  # GET /callbacks
  # GET /callbacks.json
  def index
    @callbacks = CmmCallback.all
  end

  # GET /callbacks/1
  # GET /callbacks/1.json
  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @callback }
    end
  end

  # POST /callbacks.json {JSON body}
  def create
    # pull the pa request out of the JSON
    @json = request_params

    # create a callback object to log that we received this callback
    @callback = CmmCallback.new content:@json.to_json

    # see if the PA exists already in our local database
    @pa = PaRequest.find_by_cmm_id(@json['id'])

    if @pa.nil?
      # couldn't find it in our db, must be a retrospective
      @pa = PaRequest.new
      @pa.init_from_callback(@json)
      
    else
      # if we have a record of the PA, delete it if appropriate
      if is_delete?(@json)
        @pa.update_attributes(cmm_token: nil)
      else
        # if it's not a delete, then it's an update
        @pa.update_from_callback(@json)
      end
    end
    
    @pa.save
    @callback.pa_request = @pa
    @pa.cmm_callbacks << @callback
    @callback.save!

    respond_to do |format|
      if @pa.save
        format.html { redirect_to @pa }
        format.json { render json: @pa}
      else
        format.html { render :error }
        format.json { render json: @callback }
      end
    end

  end

  private

  def is_delete?(callback)
    (callback['events'] || []).any? {|ev| ev['type'] == "DELETE"}
  end

  def request_params
    json_params = ActionController::Parameters.new( JSON.parse(request.body.read) )
    return json_params.require(:request)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def callback_params
    params.require(:callback)
  end

  def set_callback
    @callback = CmmCallback.find(params[:id])
  end
end
