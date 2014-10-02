class CallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:handle]

  # POST /callbacks/handle {URLEncoded body}
  # POST /callbacks/handle.json {JSON body}
  def handle
    # receive information about a request & handle it
    @cb_data = request_params

    # find the request in our local database
    @pa = PaRequest.find_by_cmm_id(@cb_data['id'])
    if is_delete?(@cb_data) && @pa
      # first check if it's been deleted on CoverMyMeds
      @pa.update_attributes(:cmm_token => nil)

    else
      # if it's there, must be an update callback
      if @pa
        @pa.update_from_callback(@cb_data)
        
      else
        # couldn't find it in our db, must be a retrospective
        @pa = PaRequest.new 
        @pa.init_from_callback(@cb_data)
      end

      bad_request unless @pa.save
    end

    respond_to do |format|
      format.html 
    end

  end

  private

  def is_delete?(cb_data)
    # next, check if the PA has been deleted.  if so, remove it from our list
    del = (cb_data['events'] || []).select {|ev| ev['type'] == "DELETE"}
    return !del.empty?
  end

  def bad_request
    raise ActionController::BadRequest.new('Bad Request')
  end

  def request_params
    params.require(:request)
  end
end
