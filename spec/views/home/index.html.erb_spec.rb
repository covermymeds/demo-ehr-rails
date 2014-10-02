require 'rails_helper'

RSpec.describe "home/index.html.erb", :type => :view do

  it "renders the welcome screen text" do
    render
    assert_select "div.jumbotron>h2", :text => "Lets pretend that this is your EHR..."
  end

end
