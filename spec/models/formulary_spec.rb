require 'rails_helper'

describe Formulary do

  describe '.pa_required?' do
    let (:drug_name) { SecureRandom.uuid }
    let (:banana)    { 'banana' }
    let (:prescriptions) { [
      { name: drug_name },
      { name: banana },
    ] }

    it 'returns true for bananas and false for not bananas' do
      expect(described_class.pa_required?(prescriptions)).to include({name: banana, autostart: true}, {name: drug_name, autostart: false})
    end
  end

end
