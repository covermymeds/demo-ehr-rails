require 'rails_helper'

describe FormulariesController, type: :controller do

  let (:drug_id_1) { SecureRandom.uuid }
  let (:drug_id_2) { SecureRandom.uuid }
  let (:drug_name) { SecureRandom.uuid }
  let (:banana)    { 'banana' }
  let (:valid_attributes) {
    { prescriptions: [
      { drug_id: drug_id_1, name: drug_name },
      { drug_id: drug_id_2, name: banana },
  ], } }

  describe 'POST pa_required' do
    describe 'with valid params' do
      it 'returns a JSON object indicating if the client must start a PA for each prescription' do
        post :pa_required, valid_attributes
        expect(JSON.parse(response.body)).to include('prescriptions' => [
                                         {'drug_id' => drug_id_1, 'name' => drug_name, 'autostart' => false},
                                         {'drug_id' => drug_id_2, 'name' => banana,    'autostart' => true}, ])

      end
    end
  end
end
