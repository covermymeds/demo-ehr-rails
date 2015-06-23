require 'rails_helper'

RSpec.describe "cmm_callbacks/index", :type => :view do
  before(:each) do
    CmmCallback.create!(
      :pa_request_id => 1,
      :content => '{"MyText":"myvalue"}'
    )
    CmmCallback.create!(
      :pa_request_id => 1,
      :content => '{"MyText":"my other value"}'
    )
    assign(:callbacks, CmmCallback.all.page(1))
  end

  it "renders a list of callbacks" do
    render
    assert_select "div.row", :count => 3
  end
end
