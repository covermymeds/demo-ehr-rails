require 'rails_helper'

RSpec.describe Patient, type: :model do
  # Prefix class methods with a '.'
  it 'allows first and last name, state, and date_of_birth' do
    # setup
    patient = Patient.new(first_name:'john', last_name:'doe', state:'OH', date_of_birth:'01/01/1970')

    # exercise
    patient.save

    # verify
    expect(patient).to be_valid

    # teardown is handled for you by RSpec
  end

  it 'requires first name' do
    patient = Patient.new(last_name:'doe', state:'OH', date_of_birth:'01/01/1970')
    patient.save
    expect(patient).not_to be_valid
  end

  it 'requires last name' do
    patient = Patient.new(first_name:'john', state:'OH', date_of_birth:'01/01/1970')
    patient.save
    expect(patient).not_to be_valid
  end

  it 'requires state' do 
    patient = Patient.new(first_name:'john', last_name:'doe', date_of_birth:'01/01/1970')
    patient.save
    expect(patient).not_to be_valid
  end

  it 'requires date of birth' do
    patient = Patient.new(first_name:'john', last_name:'doe', state:'OH')
    patient.save
    expect(patient).not_to be_valid
  end

  it 'requires american format dob' do
    patient = Patient.new(first_name:'john', last_name:'doe', state:'OH', date_of_birth:'July 4, 1776')
    patient.save
    expect(patient).not_to be_valid
  end

  it 'returns full name' do
    patient = Patient.new(first_name:'john', last_name:'doe', state:'OH', date_of_birth:'01/01/1970')
    full_name = patient.full_name
    expect(full_name).to eql('john doe') 
  end

  it 'returns description' do
    patient = Patient.new(first_name:'john', last_name:'doe', state:'OH', date_of_birth:'01/01/1970')
    description = patient.description
    expect(description).to eql('john doe 01/01/1970 OH')
  end
end
