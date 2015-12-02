class RequestConfigurator
  def self.request(prescription, form_id, prescriber)

    client = self.api_client

    # get a hash of request data
    new_request = client.request_data

    # we don't know the form yet, so remove it from the hash
    if form_id.blank?
      new_request.delete('form_id')
    else
      new_request.form_id = form_id
    end

    # local variables
    patient = prescription.patient
    pharmacy = prescription.pharmacy

    # required data
    new_request.patient.first_name = patient.first_name
    new_request.patient.last_name = patient.last_name
    new_request.state = patient.state
    new_request.patient.address.state = patient.state
    new_request.prescription.drug_id = prescription.drug_number

    # payer
    new_request.payer.form_search_text = nil
    new_request.payer.bin = patient.bin
    new_request.payer.pcn = patient.pcn
    new_request.payer.group_id = patient.group_id

    # merge the data from my patient
    new_request.patient.date_of_birth = patient.date_of_birth
    new_request.patient.address.street_1 = patient.street_1
    new_request.patient.address.street_2 = patient.street_2
    new_request.patient.address.city = patient.city
    new_request.patient.address.state = patient.state
    new_request.patient.address.zip = patient.zip
    new_request.patient.email = patient.email
    new_request.patient.gender = patient.gender
    new_request.patient.phone_number = patient.phone_number

    # merge prescription data
    new_request.prescription.name = prescription.drug_name
    new_request.prescription.quantity = prescription.quantity
    new_request.prescription.frequency = prescription.frequency
    new_request.prescription.refills = prescription.refills
    new_request.prescription.dispense_as_written = prescription.dispense_as_written

    # merge prescriber information
    physician = {npi: prescriber ? prescriber.npi : "1234567890",
                 first_name: prescriber ? prescriber.first_name : "James",
                 last_name: prescriber ? prescriber.last_name : "Kirk",
                 clinic: prescriber.practice_name || "The Enterprise Clinic",
                 phone_number: prescriber.practice_phone_number || "615-555-1212"
                 fax_number: prescriber.credentials.first.nil? ? "614-999-9999" : prescriber.credentials.first.fax,
                 street: prescriber.practice_street_1 || "1 Starship Way",
                 street_2: prescriber.practice_street_2 || "Apt 200",
                 city: prescriber.practice_city || "Riverside",
                 state: prescriber.practice_state || "OH",
                 zip: prescriber.practice_zip || "52327" }

    new_request.prescriber.npi = physician[:npi]
    new_request.prescriber.first_name = physician[:first_name]
    new_request.prescriber.last_name = physician[:last_name]
    new_request.prescriber.clinic = physician[:clinic]
    new_request.prescriber.fax_number = physician[:fax_number]
    new_request.prescriber.phone_number = physician[:phone_number]
    new_request.prescriber.address.street_1 = physician[:street]
    new_request.prescriber.address.street_2 = physician[:street_2]
    new_request.prescriber.address.city = physician[:city]
    new_request.prescriber.address.state = physician[:state]
    new_request.prescriber.address.zip = physician[:zip]


    # merge pharmacy information
    if pharmacy
      new_request.pharmacy.name = pharmacy.name
      new_request.pharmacy.fax_number = pharmacy.fax
      new_request.pharmacy.phone_number = pharmacy.phone
      new_request.pharmacy.address.street_1 = pharmacy.street
      new_request.pharmacy.address.city = pharmacy.city
      new_request.pharmacy.address.state = pharmacy.state
      new_request.pharmacy.address.zip = pharmacy.zip
    end

    new_request
  end

  def self.api_client
    CoverMyMeds.default_client
  end

end
