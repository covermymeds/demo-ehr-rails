class CallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:handle]

  # POST /callbacks/handle {URLEncoded body}
  # POST /callbacks/handle.json {JSON body}
  def handle
    # receive information about a request & handle it
    @callback = request_params

    # find the request in our local database
    @pa = PaRequest.find_by_cmm_id(@callback['id'])
    if is_delete?(@callback) && @pa
      # first check if it's been deleted on CoverMyMeds
      @pa.update_attributes(:cmm_token => nil)

    else
      # if it's there, must be an update callback
      if @pa
        @pa.update_from_callback(@callback)
        
      else
        # couldn't find it in our db, must be a retrospective
        @pa = PaRequest.new 
        @pa.init_from_callback(@callback)
      end

      @pa.save!
    end

    respond_to do |format|
      format.html 
    end

  end

  private

  def is_delete?(callback)
    (callback['events'] || []).any? {|ev| ev['type'] == "DELETE"}
  end

  def request_params
    params.require(:request)
  end
end
