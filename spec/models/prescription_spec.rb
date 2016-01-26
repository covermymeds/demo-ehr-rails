require 'rails_helper'

RSpec.describe Prescription, type: :model do
  let(:prescription_params) do
    {
      drug_number: '123456',
      quantity: 30,
      frequency: 'qD',
      refills: 2,
      dispense_as_written: true,
      drug_name: 'My Drug'
    }
  end

  it 'allows a pharmacy' do
    prescription = Prescription.new(prescription_params)
    prescription.patient = Patient.new(first_name: 'john', last_name: 'doe', state: 'OH', date_of_birth: '01/01/1970')
    prescription.pharmacy = Pharmacy.new(name: 'this is a pharmacy')

    prescription.save

    expect(prescription).to be_valid
  end
end
