module PrescriptionsHelper

  def patient_benefit_message(prescription)
    if prescription.sponsored_message
      prescription.sponsored_message
    elsif prescription.copay_amt
      "$#{prescription.copay_amt}"
    elsif prescription.pa_required
      "Prior Authorization Required"
    elsif prescription.predicted && !prescription.pa_required
      "Prior Authorization Not Required"
    else
      "Patient Benefit Not Available"
    end
  end

  def drug_info(drug)
    "#{drug.strength} #{drug.strength_unit_of_measure} #{drug.route_of_administration} #{drug.dosage_form}"
  end

  def address_info(address)
    "#{address.city}, #{address.state} #{address['zip']}"
  end
end
