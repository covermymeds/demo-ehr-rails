json.array!(@prescriptions) do |prescription|
  json.extract! prescription, :id, :drug_number, :quantity, :frequency, :refills, :dispense_as_written, :patient_id
  json.url prescription_url(prescription, format: :json)
end
