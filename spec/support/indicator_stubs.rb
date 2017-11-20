def stub_indicators(drug_name, pa_required)
  indicator_result = { 'indicator' =>
    {
    'prescription' => {
      'drug_id' => junk(:int, size: 6),
      'name' => drug_name,
      'pa_required' => pa_required,
      'sponsored_message' => 'Prior Authorization Required',
      'sponsored_help_message' => 'This is a helpful message for: Prior Authorization Required'
      }
    }
  }
  allow_any_instance_of(CoverMyMeds::Client).
    to receive(:post_indicators).
    and_return(Hashie::Mash.new(indicator_result))
end

def stub_indicators_additional_content
  indicator_result = { 'indicator' =>
    {
    'prescription' => {
      'drug_id' => junk(:int, size: 6),
      'name' => junk,
      'pa_required' => false,
      'additional_content' => [
        {
          "text" => "Assistance with completing and following up on the Prior Authorization is available.",
          "method" => "GET",
          "href" => "https://www.covermymeds.com/main/help/"
        },
        {
          "text" => "Common ICD-10 codes used for this medication are: W56.49, W56.22, and V91.07",
        }
      ]
      }
    }
  }
  allow_any_instance_of(CoverMyMeds::Client).
    to receive(:post_indicators).
    and_return(Hashie::Mash.new(indicator_result))
end

def stub_indicators_drug_alternatives
  indicator_result = { 'indicator' =>
    {
    'prescription' => {
      'drug_id' => junk(:int, size: 6),
      'name' => junk,
      'pa_required' => false,
      'suggested_drug_alternatives' => [
        { "name" => "Chocolate Flavor" },
        { "name" => "Butterscotch Flavor" }
      ]}
    }
  }
  allow_any_instance_of(CoverMyMeds::Client).
    to receive(:post_indicators).
    and_return(Hashie::Mash.new(indicator_result))
end

def stub_indicators_drug_qty_substitution(drug_name, pa_required)
  indicator_result = { 'indicator' =>
    {
    'prescription' => {
      'drug_id' => junk(:int, size: 6),
      'quantity_substitution_performed' => true,
      'quantity' => 115,
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
        'name': 'Walgreens',
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
        'name': 'Walgreens',
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


def stub_indicators_with_deductible_amounts(drug_id, pa_required)
  indicator_result = { 'indicator' =>
    {
    'prescription' => {
      'drug_id' => drug_id,
      'name' => drug_name,
      'pa_required' => pa_required,
      'predicted' => true,
      'applied_deductible_amt' => '15.00',
      'remaining_deductible_amt' => '275.00',
      'copay_amt' => '15.00'
      }
    }
  }
  allow_any_instance_of(CoverMyMeds::Client).
    to receive(:post_indicators).
    and_return(Hashie::Mash.new(indicator_result))
end
