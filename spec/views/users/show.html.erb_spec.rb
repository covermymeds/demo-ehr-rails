require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    role = Role.create! description: 'Doctor'
    @user = assign(:user, User.create!(
      first_name: "First",
      last_name: "Last",
      npi: "Npi",
      role_id: role.id
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Role/)
    expect(rendered).to match(/Npi/)
  end
end
