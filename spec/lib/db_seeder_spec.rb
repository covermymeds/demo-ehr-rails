require 'rails_helper'

describe DbSeeder do
  let(:first_name) { SecureRandom.uuid }
  let(:last_name) { SecureRandom.uuid }
  let(:pharmacy_name) { SecureRandom.uuid }
  let(:token) { SecureRandom.uuid }

  before do
    Patient.create! first_name: first_name, last_name: last_name, date_of_birth: '10/01/1971', state: 'OH'
    Pharmacy.create! name: pharmacy_name
    User.create! name: first_name
    PaRequest.create! cmm_token: token
    DbSeeder.seed
  end

  it 'destroys new records' do
    expect(Patient.where(first_name: first_name)).to_not exist
    expect(Pharmacy.where(name: pharmacy_name)).to_not exist
    expect(User.where(name: first_name)).to_not exist
    expect(PaRequest.where(cmm_token: token)).to_not exist
  end

  it 'creates some default records' do
    expect(Patient.count).to be > 0
    expect(Pharmacy.count).to be > 0
    expect(User.count).to be > 0
  end
end
