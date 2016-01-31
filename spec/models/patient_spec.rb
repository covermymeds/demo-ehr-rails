require 'rails_helper'

RSpec.describe Patient, type: :model do
  # Prefix class methods with a '.'
  let(:first) { 'john' }
  let(:last)  { 'doe' }
  let(:state) { 'OH' }
  let(:date_of_birth) { '01/01/1970' }
  let(:full_name) { "#{first} #{last}" }
  let(:description) { "#{full_name} #{date_of_birth} #{state}" }
  let(:patient) { Patient.new(first_name: first, last_name: last, 
                    state: state, date_of_birth: date_of_birth)}

  it 'allows first and last name, state, and date_of_birth' do
    # setup
    patient = Patient.new(first_name:'john', 
      last_name:'doe', 
      state:'OH', 
      date_of_birth:'01/01/1970')

    # exercise
    patient.save

    # verify
    expect(patient).to be_valid
  end

  it 'requires first name' do
    patient = Patient.new(
      last_name:'doe', 
      state:'OH', 
      date_of_birth:'01/01/1970')
    patient.save
    expect(patient).not_to be_valid
  end

  describe 'with nil last name' do 
    let(:last) { nil }
    it 'fails to create PA' do
      expect(patient).not_to be_valid
    end
  end

  describe 'with nil state' do 
    let(:state) { nil }
    it 'fails to create PA' do 
      expect(patient).not_to be_valid
    end
  end

  describe 'with nil date_of_birth' do
    let(:date_of_birth) { nil }
    it 'requires date of birth' do
      expect(patient).not_to be_valid
    end
  end

  describe 'with wrong format date_of_birth' do
    let(:date_of_birth) { 'July 4, 1776' }
    it 'requires american format dob' do
      expect(patient).not_to be_valid
    end
  end

  it 'provides correct full name' do
    expect(patient.full_name).to eql(full_name) 
  end

  it 'provides a good description' do
    expect(patient.description).to eql(description)
  end
end
