class RequestConfigurator

    attr_reader :request

    def initialize pa_request
        @request = CoverMyMeds.default_client.request_data
        @pa = pa_request

        assign_request_metadata
        assign_patient
        assign_prescriber 
        assign_payer
        assign_prescription
        assign_pharmacy
    end

    private

    def assign_request_metadata
        @request.form_id = @pa.form_id
        @request.delete(:form_id) if @pa.form_id.blank?
        @request.state = @pa.prescription.patient.state
        @request.urgent = @pa.urgent
    end

    def assign_patient
        patient = @pa.prescription.patient
        @request.patient.first_name        = patient.first_name
        @request.patient.last_name         = patient.last_name
        @request.patient.address.state     = patient.state
        @request.patient.date_of_birth     = patient.date_of_birth
        @request.patient.address.street_1  = patient.street_1
        @request.patient.address.street_2  = patient.street_2
        @request.patient.address.city      = patient.city
        @request.patient.address.state     = patient.state
        @request.patient.address.zip       = patient.zip
        @request.patient.email             = patient.email
        @request.patient.gender            = patient.gender
        @request.patient.phone_number      = patient.phone_number
    end

    def assign_prescriber 
        prescriber = @pa.user
        return if prescriber.nil?

        defaults = {
            :npi => '1234567890',
            :first_name => 'James',
            :last_name => 'Kirk',
            :clinic_name => 'The Enterprise',
            :phone_number => '614-555-1212',
            :fax_number => '614-999-9999',
            :address => {
                :street_1 => '1 Starship Place',
                :street_2 => 'Apt 200',
                :city => 'Columbus',
                :state => 'OH',
                :zip => '43215',
            }
        }
        @request.prescriber.phone_number = prescriber.practice_phone_number
        @request.prescriber.clinic_name = prescriber.practice_name
        @request.prescriber.address.street_1 = @pa.user.practice_street_1
        @request.prescriber.address.street_2 = @pa.user.practice_street_2
        @request.prescriber.address.city = @pa.user.practice_city
        @request.prescriber.address.state = @pa.user.practice_state
        @request.prescriber.address.zip = @pa.user.practice_zip

        @request.prescriber.each_key do |key|
            if @request.prescriber[key].blank?
                @request.prescriber[key] = prescriber.as_json.fetch(key, defaults[key])
            end
        end

        unless prescriber.credentials.empty?
            @request.prescriber.fax_number = prescriber.credentials.first.fax 
        end
    end

    def assign_payer 
        patient = @pa.prescription.patient
        return if patient.nil?
        @request.payer.each_key do | key |
            @request.payer[key] = patient.as_json.fetch(key, nil)
        end
        @request.payer.form_search_text = "#{patient.bin} #{patient.pcn} #{patient.group_id}"
    end

    def assign_prescription 
        prescription = @pa.prescription
        return if prescription.nil?
        @request.prescription.drug_id    = prescription.drug_number
        @request.prescription.name       = prescription.drug_name
        @request.prescription.quantity   = prescription.quantity
        @request.prescription.frequency  = prescription.frequency
        @request.prescription.refills    = prescription.refills
        @request.prescription.dispense_as_written = prescription.dispense_as_written
        @request.prescription.days_supply = prescription.days_supply
        @request.prescription.quantity_unit_of_measure = prescription.quantity_unit_of_measure
        @request.enumerated_fields.icd9_0 = prescription.diagnosis9
        @request.enumerated_fields.icd10_0 = prescription.diagnosis10
    end

    def assign_pharmacy 
        pharmacy = @pa.prescription.pharmacy
        return if pharmacy.nil?
        @request.pharmacy.name             = pharmacy.name
        @request.pharmacy.fax_number       = pharmacy.fax
        @request.pharmacy.phone_number     = pharmacy.phone
        @request.pharmacy.address.street_1 = pharmacy.street
        @request.pharmacy.address.city     = pharmacy.city
        @request.pharmacy.address.state    = pharmacy.state
        @request.pharmacy.address.zip      = pharmacy.zip
    end
end
