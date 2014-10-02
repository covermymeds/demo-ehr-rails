require 'rails_helper'

RSpec.describe PaRequest, :type => :model do
    let(:request_params) do
      {
        :cmm_link => 'https://blah',
        :cmm_outcome => 'Unknown',
        :cmm_workflow_status => 'New',
        :cmm_token => 'kdksksdkfadkjadf',
        :cmm_id => '123ABC',
        :form_id => 'this_is_a_form'
      }
    end
  it 'creates itself appropriately' do
    # setup
    pa_request = PaRequest.new(request_params)

    # exercise
    pa_request.save

    # verify
    expect(pa_request).to be_valid

    # teardown is handled for you by RSpec
  end

end
