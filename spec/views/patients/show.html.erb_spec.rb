require 'rails_helper'

RSpec.describe "patients/show", type: :view do
  fixtures :users, :roles

  before(:each) do
    @patient = assign(:patient, Patient.create!(
      first_name: "First Name",
      last_name: "Last Name",
      date_of_birth: "10/11/1971",
      state: "OH"
    ))
    @pharmacy = assign(:pharmacy, Pharmacy.create!(
      name: 'CVS',
      street: '123 Easy St.'
    ))
    @prescription = assign(:prescription, Prescription.create!(
      drug_number: '12345',
      drug_name: 'Nexium',
      quantity: '10',
      frequency: 'qD',
      refills: '3',
      dispense_as_written: true,
      pharmacy_id: @pharmacy.id,
      patient: @patient
    ))
    @patient.prescriptions.push(@prescription)
    @prescriptions = @patient.prescriptions
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/10\/11\/1971/)
    expect(rendered).to match(/OH/)
  end

  context "user is doctor" do
    it "shows the add prescription button" do
      session[:user_id] = users(:doctor).id
      render
      expect(rendered).to match(/Add Prescription/)
    end
  end

  context "user is not a doctor" do
    it "does not show the add prescription button" do
      session[:user_id] = users(:staff).id
      render
      expect(rendered).to_not match(/Add Prescription/)
    end
  end
end
