require 'rails_helper'

describe User, type: :model do
  fixtures :roles
  let(:npi) { "1234512345" }
  let(:first_name) { SecureRandom.uuid }
  let(:last_name) { SecureRandom.uuid }
  let(:doctor) { User.create! first_name: first_name, last_name: last_name, npi: npi, role: Role.doctor }
  let(:staff) { User.create! first_name: first_name, last_name: last_name, role: Role.staff }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:role_id) }

  it { should validate_presence_of(:role_id) }
  it { should validate_presence_of(:first_name) }
  context 'is a prescriber' do
    before { allow(subject).to receive(:prescriber?).and_return(true) }
    it { should validate_presence_of(:last_name).with_message(/Prescribers must have a last name/) }
    it { should validate_presence_of(:npi).with_message(/Prescribers must have an npi/) }
    it { should allow_value(npi).for(:npi) }
  end

  context 'is registered with CMM' do
    subject do
      doctor.registered_with_cmm = true
      doctor
    end

    it 'requires at least one credential' do
      expect(subject).to require_at_least_one_credential
    end

    context 'when the last credential is marked for deletion' do
      before do
        subject.credentials.create(fax: '800-555-1234')
        subject.credentials.destroy_all
      end

      it 'requires at least one credential' do
        expect(subject).to require_at_least_one_credential
      end
    end
  end

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
    context "when user's role is doctor" do
      it "returns true" do
        expect(doctor).to be_prescriber
      end
    end
  end
end
