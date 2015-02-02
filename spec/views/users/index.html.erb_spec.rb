require 'rails_helper'

RSpec.describe "users/index", type: :view do
  let(:first1) { SecureRandom.uuid }
  let(:last1)  { SecureRandom.uuid }
  let(:first2) { SecureRandom.uuid }
  let(:last2)  { SecureRandom.uuid }
  let(:npi1)    { SecureRandom.uuid }
  let(:npi2)    { SecureRandom.uuid }
  let(:role) { Role.create! description: 'role' }

  before(:each) do
    assign(:users, [
           User.create!(
             first_name: first1,
             last_name: last1,
             npi: npi1,
             role_id: role.id
           ),
           User.create!(
             first_name: first2,
             last_name: last2,
             npi: npi2,
             role_id: role.id
           )
    ])
    render
  end

  it "renders a list of users" do
    assert_select "tr>td", text: first1
    assert_select "tr>td", text: last1
    assert_select "tr>td", text: 'role'
    assert_select "tr>td", text: npi1
    assert_select "tr>td", text: first2
    assert_select "tr>td", text: last2
    assert_select "tr>td", text: 'role'
    assert_select "tr>td", text: npi2
  end
end
