class RequestConfigurator
  def self.request(prescription, form_id, prescriber)
    # get a hash of request data
    new_request = CoverMyMeds.default_client.request_data

    # set the high-level request information we need
    self.assign_request(new_request, form_id, prescription.patient)

    # merge information about the payer
    self.assign_payer(new_request.payer, prescription.patient)

    # merge the data from my patient
    self.assign_patient(new_request.patient, prescription.patient)

    # merge prescription data
    self.assign_prescription(new_request.prescription, prescription) if prescription

    # merge prescriber information
    self.assign_prescriber(new_request.prescriber, prescriber) if prescriber

    # merge pharmacy information
    self.assign_pharmacy(new_request.pharmacy, prescription.pharmacy) if prescription.pharmacy

    new_request
  end

  def self.assign_request hash, form, patient
    hash.delete(:form_id) if form.nil?
    hash.form_id = form unless form.nil?
    hash.state = patient.state
  end

  def self.assign_patient hash, patient
    hash.first_name        = patient.first_name
    hash.last_name         = patient.last_name
    hash.address.state     = patient.state
    hash.date_of_birth     = patient.date_of_birth
    hash.address.street_1  = patient.street_1
    hash.address.street_2  = patient.street_2
    hash.address.city      = patient.city
    hash.address.state     = patient.state
    hash.address.zip       = patient.zip
    hash.email             = patient.email
    hash.gender            = patient.gender
    hash.phone_number      = patient.phone_number
  end

  def self.assign_prescriber hash, prescriber
    hash.npi          = prescriber.npi || "1234567890" 
    hash.first_name   = prescriber.first_name || "James"
    hash.last_name    = prescriber.last_name  || "Kirk"
    hash.clinic       = prescriber.practice_name || "The Enterprise Clinic"
    hash.fax_number   = prescriber.credentials.first || "614-999-9999"
    hash.phone_number = prescriber.practice_phone_number || "615-555-1212"
    hash.address.street_1 = prescriber.practice_street_1 || "1 Starship Way"
    hash.address.street_2 = prescriber.practice_street_2 || "Apt 200"
    hash.address.city   = prescriber.practice_city || "Columbus"
    hash.address.state  = prescriber.practice_state || "OH"
    hash.address.zip    = prescriber.practice_zip || "43215"
  end

  def self.assign_payer hash, patient
    hash.form_search_text  = "#{patient.bin} #{patient.pcn} #{patient.group_id}"
    hash.bin               = patient.bin
    hash.pcn               = patient.pcn
    hash.group_id          = patient.group_id
  end

  def self.assign_prescription hash, prescription
    hash.drug_id    = prescription.drug_number
    hash.name       = prescription.drug_name
    hash.quantity   = prescription.quantity
    hash.frequency  = prescription.frequency
    hash.refills    = prescription.refills
    hash.dispense_as_written = prescription.dispense_as_written
  end

  def self.assign_pharmacy hash, pharmacy
    hash.name             = pharmacy.name
    hash.fax_number       = pharmacy.fax
    hash.phone_number     = pharmacy.phone
    hash.address.street_1 = pharmacy.street
    hash.address.city     = pharmacy.city
    hash.address.state    = pharmacy.state
    hash.address.zip      = pharmacy.zip
  end

end
