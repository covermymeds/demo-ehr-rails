require 'rails_helper'

RSpec.describe "patients/new", type: :view do
  before(:each) do
    assign(:patient, Patient.new(
      first_name: "MyString",
      last_name: "MyString",
      date_of_birth: "10/11/1971",
      state: "OH",
      bin: '773836',
      pcn: 'MOCKPBM',
      group_id: 'ABC1'
    ))
  end

  it "renders new patient form" do
    render

    assert_select "form[action=?][method=?]", patients_path, "post" do

      assert_select "input#patient_first_name[name=?]", "patient[first_name]"

      assert_select "input#patient_last_name[name=?]", "patient[last_name]"

      assert_select "input#patient_date_of_birth[name=?]", "patient[date_of_birth]"

      assert_select "select#patient_state[name=?]", "patient[state]"

      assert_select "input#patient_bin[name=?]", "patient[bin]"

      assert_select "input#patient_pcn[name=?]", "patient[pcn]"

      assert_select "input#patient_group_id[name=?]", "patient[group_id]"
    end
  end
end
