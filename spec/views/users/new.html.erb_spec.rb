require 'rails_helper'

RSpec.describe "users/new", type: :view do
  junklet :first, :last

  let(:npi)    { rand.to_s[2..11] } # junk(:int, size: 10) was returning 8 digits
  let!(:roles) { [Role.create(description: 'Doctor')] }
  let!(:user)  { User.create!(first_name: first, last_name: last, role: roles.first, npi: npi ) }

  before(:each) do
    assign(:user, User.new)
    assign(:roles, roles)
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input#user_first_name[name=?]", "user[first_name]"

      assert_select "input#user_last_name[name=?]", "user[last_name]"

      assert_select "select#user_role_id[name=?]", "user[role_id]"

      assert_select "input#user_npi[name=?]", "user[npi]"
    end
  end
end
