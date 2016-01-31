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
        @request.tap do | r |
            r.form_id = @pa.form_id
            r.delete(:form_id) if @pa.form_id.blank?
            r.state = @pa.prescription.patient.state
            r.urgent = @pa.urgent
        end
    end

    def assign_patient
        @request.patient.tap do | p |
            patient = @pa.prescription.patient
            p.first_name        = patient.first_name
            p.last_name         = patient.last_name
            p.address.state     = patient.state
            p.date_of_birth     = patient.date_of_birth
            p.address.street_1  = patient.street_1
            p.address.street_2  = patient.street_2
            p.address.city      = patient.city
            p.address.state     = patient.state
            p.address.zip       = patient.zip
            p.email             = patient.email
            p.gender            = patient.gender
            p.phone_number      = patient.phone_number
        end
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
        @request.prescriber.tap do | p |
            p.phone_number = prescriber.practice_phone_number
            p.clinic_name = prescriber.practice_name
            p.address.street_1 = @pa.user.practice_street_1
            p.address.street_2 = @pa.user.practice_street_2
            p.address.city = @pa.user.practice_city
            p.address.state = @pa.user.practice_state
            p.address.zip = @pa.user.practice_zip

            p.each_key do |key|
                if p[key].blank?
                    p[key] = prescriber.as_json.fetch(key, defaults[key])
                end
            end

            unless prescriber.credentials.empty?
                p.fax_number = prescriber.credentials.first.fax 
            end
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
        return if @pa.prescription.nil?
        prescription = @pa.prescription
        @request.prescription.tap do | p |
            p.drug_id    = prescription.drug_number
            p.name       = prescription.drug_name
            p.quantity   = prescription.quantity
            p.frequency  = prescription.frequency
            p.refills    = prescription.refills
            p.dispense_as_written = prescription.dispense_as_written
            p.days_supply = prescription.days_supply
            p.quantity_unit_of_measure = prescription.quantity_unit_of_measure
        end
        @request.enumerated_fields.tap do | e |
            e.icd9_0 = prescription.diagnosis9
            e.icd10_0 = prescription.diagnosis10
        end
    end

    def assign_pharmacy 
        return if @pa.prescription.pharmacy.nil?
        pharmacy = @pa.prescription.pharmacy
        @request.pharmacy.tap do | p |
            p.name             = pharmacy.name
            p.fax_number       = pharmacy.fax
            p.phone_number     = pharmacy.phone
            p.address.street_1 = pharmacy.street
            p.address.city     = pharmacy.city
            p.address.state    = pharmacy.state
            p.address.zip      = pharmacy.zip
        end
    end
end
