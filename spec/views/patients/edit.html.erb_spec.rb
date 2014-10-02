require 'rails_helper'

RSpec.describe "patients/edit", :type => :view do
  before(:each) do
    @patient = assign(:patient, Patient.create!(
      :first_name => "MyString",
      :last_name => "MyString",
      :date_of_birth => "10/11/1971",
      :state => "OH"
    ))
  end

  it "renders the edit patient form" do
    render

    assert_select "form[action=?][method=?]", patient_path(@patient), "post" do

      assert_select "input#patient_first_name[name=?]", "patient[first_name]"

      assert_select "input#patient_last_name[name=?]", "patient[last_name]"

      assert_select "input#patient_date_of_birth[name=?]", "patient[date_of_birth]"

      assert_select "select#patient_state[name=?]", "patient[state]"
    end
  end
end
