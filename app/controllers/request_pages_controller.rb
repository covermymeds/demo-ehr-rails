require 'rest_client'

class RequestPagesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:action]
  before_action :set_request_pages
  before_action :redirect_if_using_cmm

  def index
    # get the request-page for our current request
    @request_page_json = CoverMyMeds.default_client.get_request_page(@pa_request.cmm_id, @pa_request.cmm_token)

    # redirect to my own controller for executing actions
    mask_actions @request_page_json, @pa_request

    # make rendering easy
    @forms = @request_page_json[:forms]
    @data = @request_page_json[:data]
    @validations = @request_page_json[:validations]
    @actions = @request_page_json[:actions]

  rescue CoverMyMeds::Error::HTTPError => e
    flash_message "Error retrieving the request page: #{e.message}", :error
    redirect_to :back
  end

  def action
    bad_request unless params[:button_title]

    # look up the action from our list of saved actions for this PA
    actions = JSON.parse(@pa_request.request_pages_actions, symbolize_names: true)
    action = actions.select { |action| action[:title] == params[:button_title] }.first

    bad_request unless action

    # now we have the "real" action, let's execute it
    headers = {
      accept: 'application/json',
      user_agent: 'Request Pages Example Client'
    }

    # build an HTTP connection
    conn = RestClient::Resource.new(action[:href],
                                    user: Rails.application.secrets.cmm_api_id,
                                    password: 'x-no-pass',
                                    headers: headers
    )

    # important: look up the form data to be included
    form_data = {}
    unless action[:ref].nil? || params[action[:ref]].nil?
      form_data = params[action[:ref]].delete_if { |_, v| v.blank? }
    end

    begin
      # call out to get the next request page
      response = conn.send( action[:method].downcase, form_data )

      flash_message("#{action[:title]} completed successfully", :notice)

      # the body of our response is in request_pages format
      @request_page_json = JSON.parse(response.body, symbolize_names: true)
      @request_page = @request_page_json[:request_page]

      # if we got back a standard pa_request page, show that
      if pa_request_form? @request_page
        redirect_to pages_pa_request_path(@pa_request)
      else
        # otherwise, render the action
        mask_actions @request_page, @pa_request
        @forms = @request_page[:forms]
        @data = @request_page[:data]
        @validations = @request_page[:validations]
        @actions = @request_page[:actions]

        render :index
      end

    rescue CoverMyMeds::Error::HTTPError => e
      flash_message "API error retrieving the request page: #{e.message}:#{e.response}", :error
      redirect_to pages_pa_request_path(@pa_request)

    rescue RestClient::Exception => e
      flash_message "Network error retrieving the request page: #{e.message}:#{e.response}", :error
      redirect_to pages_pa_request_path(@pa_request)

    rescue StandardError => e
      flash_message "An unknown error occurred: #{e.message}", :error
      redirect_to pages_pa_request_path(@pa_request)
    end

  end

  private

  def bad_request
    raise ActionController::BadRequest.new('Bad Request')
  end

  def pa_request_form?(request_page)
    request_page[:forms].has_key?(:pa_request)
  end

  # proxy actions through this controller, keeping tokens in the server
  def mask_actions request_page, pa_request
    # keep track of actions, so we can execute actions
    actions = request_page[:actions]
    pa_request.update_attributes request_pages_actions: actions.to_json

    # replace actions in json (don't send tokens to browser)
    actions.each do |action|
      action[:orig_href] = action[:href] # so we see it in the JSON source
      action[:orig_method] = action[:method]
      action[:href] = action_pa_request_path(@pa_request, action[:title])
      action[:method] = 'GET'
    end
  end

  # before actions to set up instance vars & do a redirect
  def set_request_pages
    # pa_request is passed in with the URL
    @pa_request = PaRequest.find(params[:id])

    # patient & prescription are used for debugging mostly
    @patient = @pa_request.prescription.patient
    @prescription = @pa_request.prescription
  end

  def redirect_if_using_cmm
    return unless @_use_custom_ui == false
    redirect_to @pa_request.cmm_link
  end

end
