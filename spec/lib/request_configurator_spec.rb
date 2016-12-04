require 'rails_helper'

RSpec.describe RequestConfigurator, type: :model do
  fixtures :roles

  context 'when creating a request' do 
    junklet :fax_number, 
      :form_id, 
      :first_name, 
      :last_name, 
      :state,
      :pcn,
      :group_id,
      :drug_benefit_name,
      :medical_benefit_name,
      :drug_name,
      :city,
      :street,
      :phone_number,
      :pharmacy_name

    let(:bin) { junk(:int, size: 6).to_s }
    let(:form_search_text) { "#{bin} #{pcn} #{group_id}" }
    let(:zip) { junk(:int, size: 5) }
    let(:urgent) { junk :bool }

    let(:npi) { junk(:int, size: 10).to_s }

    let(:date_of_birth) do
      year = 1965
      month = junk :int, min: 1, max: 12
      day = junk :int, min:1, max: 28
      junk -> { Date.new(year, month, day).strftime('%d/%m/%Y') }
    end

    let(:credential) { Credential.create! fax: fax_number }
    let(:prescriber_params) do
      {
        first_name: first_name,
        last_name: last_name,
        practice_state: state,
        practice_city: city,
        practice_zip: zip,
        npi: npi,
        role: Role.doctor,
        credentials: [ credential ],
      }
    end

    let(:prescriber) do
      User.create! prescriber_params
    end

    let(:patient_params) do
      {
        first_name: first_name,
        last_name: last_name,
        date_of_birth: date_of_birth,
        state: state,
        bin: bin,
        pcn: pcn,
        group_id: group_id,
      }
    end

    let(:patient) do
      Patient.create! patient_params
    end

    let(:pharmacy_params) do
      {
        name: pharmacy_name,
        street: street,
        city: city,
        state: state,
        fax: fax_number,
        phone: phone_number,
      }
    end

    let(:pharmacy) do
      Pharmacy.create! pharmacy_params
    end

    let(:drug_number) { junk :int, size: 11 }

    let(:prescription_params) do
      {
        drug_number: drug_number,
        drug_name: drug_name,
        patient: patient,
        pharmacy: pharmacy,
      }
    end

    let(:prescription) do
      Prescription.create! prescription_params
    end

    let(:request_params) do
      {
        form_id: form_id,
        state: state,
        user: prescriber,
        urgent: urgent,
        prescription: prescription,
      }
    end

    let(:pa) do
      PaRequest.create! request_params
    end

    let(:request) do
      RequestConfigurator.new(pa).request
    end

    it 'populates prescription' do
      expect(request.prescription.drug_id).to eq(drug_number.to_s)
      expect(request.prescription.name).to eq(drug_name)
    end

    it 'populates payer' do
      expect(request.payer.bin).to eq(bin)
      expect(request.payer.pcn).to eq(pcn)
      expect(request.payer.group_id).to eq(group_id)
      expect(request.payer.form_search_text).to eq(form_search_text)
    end

    it 'populates metadata' do
      expect(request.form_id).to eq(form_id)
      expect(request.state).to eq(state)
      expect(request.urgent).to eq(urgent)
    end

    context 'when form_id is null' do
      let(:form_id) { nil }
      it 'removes the form_id param from the hash' do
        expect(request.keys.include?('form_id')).to eq(false)
      end
    end

    it 'populates pharmacy' do
      expect(request.pharmacy.name).to eq(pharmacy_name)
    end

    it 'populates prescriber' do
      expect(request.prescriber.first_name).to eq(first_name)
      expect(request.prescriber.last_name).to eq(last_name)
      expect(request.prescriber.address.state).to eq(state)
      expect(request.prescriber.fax_number).to eq(fax_number)
    end

    it 'populates patient' do
      expect(request.patient.first_name).to eq(first_name)
      expect(request.patient.last_name).to eq(last_name)
      expect(request.patient.date_of_birth).to eq(date_of_birth)
      expect(request.patient.address.state).to eq(state)
    end

  end

end
