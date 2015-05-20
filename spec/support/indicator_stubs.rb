def stub_indicators(drug_name, pa_required)
  indicator_result = {'prescriptions' => [{ 'drug_id' => junk(:int, size: 6), 'name' => drug_name, 'pa_required' => pa_required }] }
  expect_any_instance_of(CoverMyMeds::Client).to receive(:search_indicators).and_return(Hashie::Mash.new(indicator_result))
end
