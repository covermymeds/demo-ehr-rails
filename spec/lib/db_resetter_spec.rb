require 'rails_helper'

describe DbResetter do
  junklet :first_name, :last_name, :pharmacy_name, :token

  before do
    Patient.create! first_name: first_name, last_name: last_name, date_of_birth: '10/01/1971', state: 'OH'
    Pharmacy.create! name: pharmacy_name
    Role.create! description: Role::DOCTOR
    User.create! first_name: first_name, last_name: last_name, role: Role.doctor, npi: junk(:int, size: 10).to_s
    PaRequest.create! cmm_token: token
    DbResetter.reset
  end

  it 'destroys new records' do
    expect(Patient.where(first_name: first_name)).to_not exist
    expect(Pharmacy.where(name: pharmacy_name)).to_not exist
    expect(User.where(first_name: first_name)).to_not exist
    expect(PaRequest.where(cmm_token: token)).to_not exist
  end

  it 'creates some default records' do
    expect(Patient.count).to be > 0
    expect(Pharmacy.count).to be > 0
    expect(User.count).to be > 0
  end
end
