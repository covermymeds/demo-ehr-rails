require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
             User.create!(
             name: "Name 1",
             npi: "Npi 1"
           ),
             User.create!(
               name: "Name 2",
               npi: "Npi 2"
             )
           ])
    render
  end

  it "renders a list of users" do
    assert_select "tr>td", text: "Name 1".to_s
    assert_select "tr>td", text: "Npi 1".to_s
    assert_select "tr>td", text: "Name 2".to_s
    assert_select "tr>td", text: "Npi 2".to_s
  end
end
