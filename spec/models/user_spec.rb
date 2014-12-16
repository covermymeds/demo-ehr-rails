require 'rails_helper'

describe User, :type => :model do
  describe "#prescriber?" do
    let(:user) { User.new name: 'Test McTestface', npi: npi }
    
    context "when user has a valid NPI number" do
      let(:npi) { "1234512345" }
      
      it "returns true" do
        expect(user).to be_prescriber
      end
    end
  end
end
