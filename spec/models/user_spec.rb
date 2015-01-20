require 'rails_helper'

describe User, type: :model do
  fixtures :roles
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:role_id) }

  let(:npi) { "1234512345" }
  let(:first_name) { SecureRandom.uuid }
  let(:last_name) { SecureRandom.uuid }
  let(:doctor) { User.create! first_name: first_name, last_name: last_name, npi: npi, role: Role.doctor }
  let(:staff) { User.create! first_name: first_name, last_name: last_name, role: Role.staff }

  describe "#display_name" do
    context "user is a doctor" do
      it "displays 'Dr. First Last'" do
        expect(doctor.display_name).to eq("Dr. #{first_name} #{last_name}")
      end
    end
    context "user is staff" do
      it "displays 'First Last'" do
        expect(staff.display_name).to eq("#{first_name} #{last_name}")
      end
    end
  end

  describe "#prescriber?" do
    context "when user has a valid NPI number" do
      it "returns true" do
        expect(doctor).to be_prescriber
      end
    end
  end
end
