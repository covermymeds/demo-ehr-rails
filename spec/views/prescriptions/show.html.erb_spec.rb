require 'rails_helper'

RSpec.describe "prescriptions/show", type: :view do
  before(:each) do
    @pharmacy = assign(:pharmacy, Pharmacy.create!(
      name: 'cvs'
    ))

    @patient = assign(:patient, Patient.create!(
      first_name: "FirstName",
      last_name: "LastName",
      date_of_birth: "01/01/1971",
      state: "OH"
    ))
    @prescription = assign(:prescription, Prescription.create!(
      drug_number: 12345,
      quantity: 1,
      frequency: "qD",
      refills: 2,
      dispense_as_written: false,
      patient: @patient,
      pharmacy: @pharmacy
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/12345/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/qD/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
  end
end
