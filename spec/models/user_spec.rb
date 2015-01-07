require 'rails_helper'

describe User, type: :model do
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:role_id) }

  describe "#prescriber?" do
    let(:user) { User.new first_name: 'Test McTestface', npi: npi }

    context "when user has a valid NPI number" do
      let(:npi) { "1234512345" }

      it "returns true" do
        expect(user).to be_prescriber
      end
    end
  end
end
