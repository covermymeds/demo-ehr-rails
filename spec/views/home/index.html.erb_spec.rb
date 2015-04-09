require 'rails_helper'

describe "home/index.html.erb", type: :view do
  fixtures :roles, :users

  before do
    @demo_doctor = assign(:demo_doctor, User.doctors.first)
    render
  end

  it "renders the welcome screen text" do
    expect(rendered).to match /Let's pretend that this is your EHR.../
  end
end

