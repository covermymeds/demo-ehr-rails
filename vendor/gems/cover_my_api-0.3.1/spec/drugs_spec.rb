require 'spec_helper'

describe 'Drugs' do

  let(:api_id) {'LetsDoThis'}
  let(:client) { CoverMyApi::Client.new(api_id)}

  

  context 'search' do
    let(:drug)    {'Boniva'}
    let(:version) { 1 }
    before do
      stub_request(:get, "https://LetsDoThis:@api.covermymeds.com/drugs/?q=#{drug}&v=#{version}").
        to_return( status: 200, body: fixture('drugs.json'))
    end

    it 'makes methods from json' do
      drugs = client.drug_search drug
      drugs.should be_a Array
      single_drug = drugs.first
      single_drug.id.should eq                        '093563'
      single_drug.name.should eq                      'Boniva'
      single_drug.gpi.should eq                       '30042048100360'
      single_drug.sort_group.should                   be_nil
      single_drug.sort_order.should                   be_nil
      single_drug.route_of_administration.should eq   'OR'
      single_drug.dosage_form.should eq               'TABS'
      single_drug.strength.should eq                  '150'
      single_drug.strength_unit_of_measure.should eq  'MG'
      single_drug.full_name.should eq                 'Boniva 150MG tablets'
      single_drug.href.should eq                      'https://staging.api.covermymeds.com/drugs/093563'
    end
  end
end
