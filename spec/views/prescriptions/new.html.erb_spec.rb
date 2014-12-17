require 'rails_helper'

RSpec.describe "prescriptions/new", type: :view do
  before(:each) do
    @patient = assign(:patient, Patient.create!(
      first_name: "Mark",
      last_name: "Harris",
      date_of_birth: "10/11/1971",
      state: "OH"
      ))
    @prescription = assign(:prescription, Prescription.new(
      drug_number: "MyString",
      quantity: 1,
      frequency: "MyString",
      refills: 1,
      dispense_as_written: false,
      patient_id: @patient.id
      ))
  end

  it "renders new prescription form" do
    render

    assert_select "form[action=?][method=?]", patient_prescriptions_path(@patient), "post" do

      assert_select "input#prescription_drug_number[name=?]", "prescription[drug_number]"

      assert_select "input#prescription_quantity[name=?]", "prescription[quantity]"

      assert_select "select#prescription_frequency[name=?]", "prescription[frequency]"

      assert_select "select#prescription_refills[name=?]", "prescription[refills]"

      assert_select "input#prescription_dispense_as_written[name=?]", "prescription[dispense_as_written]"
    end
  end
end
