require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  junklet :first, :last

  let(:npi)    { rand.to_s[2..11] } # junk(:int, size: 10) was returning 8 digits
  let!(:user)  { User.create!(first_name: first, last_name: last, role_id: 1, npi: npi ) }
  let!(:roles) { [Role.create(description: 'Doctor')] }

  before(:each) do
    @user = assign(:user, user)
    @demo_doctor = assign(:demo_doctor, user)
    @roles = assign(:roles, roles)
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input#user_first_name[name=?]", "user[first_name]"

      assert_select "input#user_last_name[name=?]", "user[last_name]"

      assert_select "select#user_role_id[name=?]", "user[role_id]"

      assert_select "input#user_npi[name=?]", "user[npi]"
    end
  end
end
