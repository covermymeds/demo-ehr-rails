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
end
