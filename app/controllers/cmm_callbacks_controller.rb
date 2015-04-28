class CmmCallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:create]

  http_basic_authenticate_with name: "hello", password: "there"
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
  # this is the method that is called directly by CoverMyMeds when a PA is created
  # retrospectively by a pharmacist. This method needs to create a new PA record in
  # the demo system, and respond appropriately, if it can match the PA to a prescription
  # that we created previously.

  # this method is also called whenever the status or a value of a property in the PA
  # changes. In that case, we need to update the PA record in our system with the
  # new values in the callback.
  def create
    # pull the pa request out of the JSON
    @request = request_params

    # create a callback object to log that we received this callback
    @callback = CmmCallback.new content: @request.to_json

    # see if the PA exists already in our local database
    @pa = PaRequest.find_by_cmm_id(@request['id'])

    if @pa.nil?
      # couldn't find it in our db, must be a retrospective
      @pa = PaRequest.new
      @pa.init_from_callback(@request)
    else
      # if we have a record of the PA, delete it if appropriate
      if is_delete?(@request)
        @pa.update_attributes(cmm_token: nil)
      else
        # if it's not a delete, then it's an update
        @pa.update_from_callback(@request)
      end
    end

    # save our updated PA, and keep track of the callback that spawned it
    @pa.save
    @callback.pa_request = @pa
    @pa.cmm_callbacks << @callback
    @callback.save!

    # send our response back to CMM
    respond_to do |format|
      if @pa.save
        format.html { render status: 200, nothing: true }
        format.json { render json: @pa }
      else
        format.html { render :error }
        format.json { render json: @callback }
      end
    end
  end

  protected
  def authenticate
    authenticate_with_http_basic do |username, password|
      username == "hello" && password == "there"
    end
  end

  private

  def is_delete?(callback)
    (callback['events'] || []).any? {|ev| ev['type'] == "DELETE"}
  end

  def request_params
    #json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
    return params.require(:request)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def callback_params
    params.require(:callback)
  end

  def set_callback
    @callback = CmmCallback.find(params[:id])
  end
end
