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

  describe '#rxbc_test_case_drug' do
    [
      ['Flonase Allergy Relief 50MCG/ACT suspensions', '54868371800', nil      ],
      ['Eliquis 2.5MG tablets',                        '00003089321', '1364441'],
      ['TEGretol 100MG/5ML suspensions',               '00078051005', '866303' ],
      ['Vytorin 10-10MG tablets',                      '54868525901', '1245449']
    ].each do |drug_name, drug_number, rxnorm|
      it "returns drug_number #{drug_number} and rxnorm #{rxnorm} for #{drug_name}" do
        prescription = Prescription.new(prescription_params.merge(drug_name: drug_name))
        expect(prescription.rxbc_test_case_drug).to eq(Hash[drug_number: drug_number, rxnorm: rxnorm])
      end
    end
  end
end
