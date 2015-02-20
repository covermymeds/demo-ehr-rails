require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  junklet :first, :last

  before(:each) do
    @user = assign(:user, User.create!(
      first_name: first,
      last_name: last,
      role_id: 1,
      npi: junk(10),
    ))
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
