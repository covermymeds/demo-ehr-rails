require 'rails_helper'

describe User, type: :model do
  fixtures :roles
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
    context "when user's role is doctor" do
      it "returns true" do
        expect(doctor).to be_prescriber
      end
    end
  end

  describe ".find_demo_user_by_role" do
    let!(:demo_doctor) { User.where(last_name: 'Fleming').first }
    let!(:demo_staff)  { User.where(first_name: 'Staff').first }

    context "when the role is doctor" do
      it 'returns Dr. Flemming' do
        expect(User.find_demo_user_by_role('doctor')).to eq(demo_doctor)
      end
    end
    context "when the role is staff" do
      it 'returns the Staff Demo user' do
        expect(User.find_demo_user_by_role('staff')).to eq(demo_staff)
      end
    end
    context "when the role is not valid" do
      it 'raises an error' do
        expect { User.find_demo_user_by_role(nil) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { User.find_demo_user_by_role('plumber') }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
