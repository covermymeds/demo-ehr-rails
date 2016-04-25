require 'rails_helper'

describe DbResetter do
  junklet :first_name, :last_name, :pharmacy_name, :token

  before do
    patient = Patient.create! first_name: first_name, last_name: last_name, date_of_birth: '10/01/1971', state: 'OH'
    Pharmacy.create! name: pharmacy_name
    Role.create! description: Role::DOCTOR
    u = User.create! first_name: first_name, last_name: last_name, role: Role.doctor, npi: junk(:int, size: 10).to_s
    prescription = Prescription.create! patient: patient, drug_number: '123456', quantity: 30, frequency: 'qD', refills: 2, dispense_as_written: true, drug_name: 'My Drug'
    PaRequest.create! cmm_token: token, prescription: prescription
    response = Hashie::Mash.new(JSON.parse(File.read('spec/fixtures/created_pa.json')))
    allow_any_instance_of(CoverMyMeds::Client).to receive(:create_request).and_return(response)
    u.alerts.create! message: 'this is a test of the emergency broadcast system'
    DbResetter.reset
  end

  it 'destroys new records' do
    expect(Patient.where(first_name: first_name)).to_not exist
    expect(Pharmacy.where(name: pharmacy_name)).to_not exist
    expect(User.where(first_name: first_name)).to_not exist
    expect(PaRequest.where(cmm_token: token)).to_not exist
    expect(Alert.count).to eq(0)
  end

  it 'creates some default records' do
    expect(Patient.count).to be > 0
    expect(Pharmacy.count).to be > 0
    expect(User.count).to be > 0
  end
end
