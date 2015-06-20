require 'rails_helper'

RSpec.describe PaRequest, type: :model do
  let(:request_params) do
    {
      cmm_link: 'https://blah',
      cmm_outcome: 'Unknown',
      cmm_workflow_status: 'New',
      cmm_token: 'kdksksdkfadkjadf',
      cmm_id: '123ABC',
      form_id: 'this_is_a_form',
      prescriber_id: 1,
    }
  end

  context "validations" do
    context "with valid arguments" do
      it 'is valid' do
        pa_request = PaRequest.new(request_params)
        expect(pa_request).to be_valid
      end
    end
  end
end
