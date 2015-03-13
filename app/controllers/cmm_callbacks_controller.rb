class CmmCallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:index, :show, :create]

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
      format.json { render :show, status: :ok, location: @callback }
    end
  end

  # POST /callbacks.json {JSON body}
  def create
    @json = params.fetch(:request)

    # receive information about a request & handle it
    @callback = CmmCallback.new content:params['request'].to_s

    # find the request in our local database
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
        format.html { redirect_to cmm_callback_url(@callback) }
      else
        format.html { render :error }
      end
    end

  end

  private

  def is_delete?(callback)
    (callback['events'] || []).any? {|ev| ev['type'] == "DELETE"}
  end

  def request_params
    params.require(:request)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def callback_params
    params.require(:callback)
  end

  def set_callback
    @callback = CmmCallback.find(params[:id])
  end
end
