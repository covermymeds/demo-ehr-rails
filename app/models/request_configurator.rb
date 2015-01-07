class RequestConfigurator
   def self.request(prescription, form_id)

      client = self.api_client

      # get a hash of request data
      new_request = client.request_data

      # we don't know the form yet, so remove it from the hash
      if form_id == nil || form_id == ""
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
      # for now, just hard code doctor information.  Technically, this would come from the
      # currently logged in user, or some other way of selecting the physician.
      physician = {npi: "1234567890",
        first_name: "James",
        last_name: "Kirk",
        clinic: "The Enterprise Clinic",
        fax_number: "555-555-5555",
        street: "1 Starship Way",
        city: "Riverside",
        state: "OH",
        zip: "52327" }

      new_request.prescriber.npi = physician[:npi]
      new_request.prescriber.first_name = physician[:first_name]
      new_request.prescriber.last_name = physician[:last_name]
      new_request.prescriber.clinic = physician[:clinic]
      new_request.prescriber.fax_number = physician[:fax_number]
      new_request.prescriber.address.street_1 = physician[:street]
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
      api_id      = Rails.application.secrets.cmm_api_id
      api_secret  = Rails.application.secrets.cmm_api_secret
      client = CoverMyApi::Client.new(api_id, api_secret)
    end
end
