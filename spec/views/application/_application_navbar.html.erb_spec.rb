require 'rails_helper'

describe "application/_application_navbar.html.erb", :type => :view do

  before do
    render
  end
  
  context "Sign in menu" do
    [ "Sign in",
      "Account Settings",
      "Sign in as Dr. Alexander Fleming",
      "Sign in as Staff",
      "Sign out"
    ].each do |expected|
      it "renders #{expected}" do
        expect(rendered).to match expected
      end
    end
  end

  context "Resources menu" do
    [ "Resources",
      "API Documentation",
      "Source Code" ].each do |expected|
      it "renders #{expected}" do
        expect(rendered).to match expected
      end
    end
  end
  
end
