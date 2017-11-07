module PrescriptionsHelper

  def patient_benefit_message(prescription)
    if !prescription.sponsored_message.blank?
      prescription.sponsored_message
    elsif !prescription.copay_amt.blank?
      "$#{prescription.copay_amt}"
    elsif prescription.pa_required
      "Prior Authorization Required"
    elsif prescription.predicted && !prescription.pa_required
      "Prior Authorization Not Required"
    else
      "Product Not Covered"
    end
  end

  def prescriber_info(prescriber_hash)
    Hashie::Mash.new(prescriber_hash)
  end

  def format_phone(phone_number)
    return '' if phone_number.nil?
    phone_number.gsub(/(\d{3})(\d{3})(\d{4})/, '\1-\2-\3')
  end

  def drug_info(drug)
    "#{drug.strength} #{drug.strength_unit_of_measure} #{drug.route_of_administration} #{drug.dosage_form}"
  end

  def address_info(address)
    "#{address.city}, #{address.state} #{address['zip']}"
  end
end
