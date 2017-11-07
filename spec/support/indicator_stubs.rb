def stub_indicators(drug_name, pa_required)
  indicator_result = { 'indicator' =>
    {
    'prescription' => {
      'drug_id' => junk(:int, size: 6),
      'name' => drug_name,
      'pa_required' => pa_required
      }
    }
  }
  allow_any_instance_of(CoverMyMeds::Client).
    to receive(:post_indicators).
    and_return(Hashie::Mash.new(indicator_result))
end


def stub_indicators_drug_substitution(id, drug_name, pa_required)
  indicator_result = { 'indicator' =>
    {
    'prescription' => {
      'drug_id' => id,
      'drug_substitution_performed' => true,
      'drug_substitution_help_message' => "Price estimate is based on frequency prescribed alternative",
      'name' => drug_name,
      'pa_required' => pa_required,
      'predicted' => true
      }
    }
  }
  allow_any_instance_of(CoverMyMeds::Client).
    to receive(:post_indicators).
    and_return(Hashie::Mash.new(indicator_result))
end


def stub_indicators_pharmacy_substitution(drug_name, pa_required)
  indicator_result = { 'indicator' =>
    {
      'prescription' => {
        'drug_id' => junk(:int, size: 6),
        'name' => drug_name,
        'pa_required' => pa_required,
        'predicted' => true
      },
      'pharmacy' => {
        'pharmacy_substitution_performed': true,
        'id': 1423775,
        'name': 'CVS PHARMACY',
        'npi': '1154418325',
        'ncpdp': '3674997',
        'phone': '5555555555',
        'fax': '',
        'address': {
          'state': 'OH',
          'street_1': '3575 BROADWAY',
          'street_2': '',
          'city': 'GROVE CITY',
          'zip': '43123'
        }
      }
    }
  }
  allow_any_instance_of(CoverMyMeds::Client).
    to receive(:post_indicators).
    and_return(Hashie::Mash.new(indicator_result))
end

def stub_indicators_pharmacy_drug_substitution(drug_id, pa_required)
  indicator_result = { 'indicator' =>
    {
      'prescription' => {
        'drug_id' => drug_id,
        'drug_substitution_performed' => true,
        'name' => drug_name,
        'pa_required' => pa_required,
        'predicted' => true,
        'copay_amt' => '15.00',
        'disclaimer_message' => 'The patient pay amount is an estimate at the pharmacy aforementioned above'
      },
      'pharmacy' => {
        'pharmacy_substitution_performed': true,
        'id': 1423775,
        'name': 'CVS PHARMACY',
        'npi': '1154418325',
        'ncpdp': '3674997',
        'phone': '5555555555',
        'fax': '',
        'address': {
          'state': 'OH',
          'street_1': '3575 BROADWAY',
          'street_2': '',
          'city': 'GROVE CITY',
          'zip': '43123'
        }
      }
    }
  }
  allow_any_instance_of(CoverMyMeds::Client).
    to receive(:post_indicators).
    and_return(Hashie::Mash.new(indicator_result))
end
