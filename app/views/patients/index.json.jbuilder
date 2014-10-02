json.array!(@patients) do |patient|
  json.extract! patient, :id, :first_name, :last_name, :date_of_birth, :state
  json.url patient_url(patient, format: :json)
end
