class Formulary

  def self.pa_required? patient, prescription, pharmacy
    rxbc_drug = prescription.rxbc_test_case_drug
    result = CoverMyMeds.default_client.post_indicators(
      prescription: {
        drug_id: rxbc_drug[:drug_number],
        name: prescription.drug_name,
        quantity: prescription.quantity
      },
      patient: patient.to_patient_hash,
      payer: patient.to_payer_hash,
      prescriber: patient.to_prescriber_hash,
      pharmacy: pharmacy.to_pharmacy_hash,
      rxnorm: rxbc_drug[:rxnorm])

    # for purposes of demonstration, vanilla flavors require PA
    # while chocolate flavors are auto-started and require Patient
    rx = result['indicator']['prescription']
    drug_name = rx['name'].downcase
    rx['pa_required'] ||= (drug_name.include?("vanilla") || drug_name.include?("chocolate"))
    rx['autostart'] ||= drug_name.include?("chocolate")

    result
  end

end
