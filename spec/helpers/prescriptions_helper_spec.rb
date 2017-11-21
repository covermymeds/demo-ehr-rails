require 'rails_helper'

RSpec.describe PrescriptionsHelper, :type => :helper do
  let(:prescription) do
    Hashie::Mash.new(
      {
        sponsored_message: nil,
        copay_amt: nil,
        pa_required: nil,
        predicted: nil
      }
    )
  end

  describe "#patient_benefit_message" do
    context "when there is a sponsored message" do
      it "returns the sponsored message" do
        prescription.sponsored_message = 'Sponsored Message'
        expect(helper.patient_benefit_message(prescription)).to eq('Sponsored Message')
      end
    end

    context "when there is a copay amount" do
      it "returns the copay amount" do
        prescription.copay_amt = '15.00'
        expect(helper.patient_benefit_message(prescription)).to eq('$15.00')
      end
    end

    context "when pa is required" do
      it "returns pa required" do
        prescription.pa_required = true
        expect(helper.patient_benefit_message(prescription)).to eq('Prior Authorization Required')
      end
    end

    context "when pa is not required" do
      it "returns pa not required" do
        prescription.pa_required = false
        prescription.predicted = true
        expect(helper.patient_benefit_message(prescription)).to eq('Prior Authorization Not Required')
      end
    end

    context "when patient beneifit is not available" do
      it "returns patient benefit not available" do
        expect(helper.patient_benefit_message(prescription)).to eq('Patient Benefit Not Available')
      end
    end
  end

  describe "#drug_info" do
    let(:drug) do
      Hashie::Mash.new(strength: 20, strength_unit_of_measure: "MG",
                       route_of_administration: "ORAL", dosage_form: "Tablet")
    end

    it "returns a string of drug information" do
      expect(helper.drug_info(drug)).to eq("20 MG ORAL Tablet")
    end
  end

  describe "#address_info" do
    let(:address) do
      Hashie::Mash.new(city: "Columbus", state: "OH", zip: "44401")
    end

    it "returns a string of address information" do
      expect(helper.address_info(address)).to eq("Columbus, OH 44401")
    end
  end

  describe "#format_phone" do
    Hash[
      "number with no symbols"        => ["5557241234", "555-724-1234"],
      "number with dashes"            => ["555-724-1234", "555-724-1234"],
      "nubmer with parentheses"       => ["(555) 724-1234", "(555) 724-1234"],
    ].each do |context_name, input_value_with_result|
      context context_name do
        it "returns the correctly formatted phone number" do
          expect(helper.format_phone(input_value_with_result[0])).to eq(input_value_with_result[1])
        end
      end
    end
  end

  describe "prescriber_info" do
    let(:prescriber_hash) do
      {
        first_name: "Andrew",
        last_name: "Fleming",
        fax_number: "6145555554",
        phone_number: "7256489633"
      }
    end

    it "returns a prescriber object" do
      [:first_name, :last_name, :fax_number, :phone_number].each do |attribute|
        expect(helper.prescriber_info(prescriber_hash)).to respond_to(attribute)
      end
    end
  end
end
