require 'rails_helper'

RSpec.describe "cmm_callbacks/show", :type => :view do
  before(:each) do
    @pa = PaRequest.create!(cmm_id:'1234')
    @callback = assign(:callback, CmmCallback.create!(
                         :content => "{\"MyText\":\"hello\"}",
                         pa_request: @pa
    ))
  end

  it "renders attributes in <code>" do
    render
    expect(rendered).to match(/MyText/)
  end
end
