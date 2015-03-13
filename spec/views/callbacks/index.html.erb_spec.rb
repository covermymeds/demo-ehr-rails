require 'rails_helper'

RSpec.describe "callbacks/index", :type => :view do
  before(:each) do
    assign(:callbacks, [
      Callback.create!(
        :content => "MyText"
      ),
      Callback.create!(
        :content => "MyText"
      )
    ])
  end

  it "renders a list of callbacks" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
