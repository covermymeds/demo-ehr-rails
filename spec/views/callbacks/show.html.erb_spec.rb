require 'rails_helper'

RSpec.describe "callbacks/show", :type => :view do
  before(:each) do
    @callback = assign(:callback, Callback.create!(
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
  end
end
