require 'spec_helper'

describe 'Forms' do
  let(:api_id) {'LetsDoThis'}
  let(:client) { CoverMyApi::Client.new(api_id)}
  let(:version){ 1 }

  context 'search' do
    let(:drug_id) { '093563' }
    let(:form)    {'anthem'}
    let(:state)   {'oh'}
    let(:drug)    {'Boniva'}
    let(:version) { 1 }

    before do
      stub_request(:get, "https://LetsDoThis:@api.covermymeds.com/forms/?drug_id=#{drug_id}&state=#{state}&q=#{form}&v=#{version}")
      .to_return( status: 200, body: fixture('forms.json'))
    end

    it 'returs matching forms' do
      forms = client.form_search(form, drug_id, state)
      single_form = forms.first
      single_form.id.should               eq 15257
      single_form.href.should             eq 'https://staging.api.covermymeds.com/forms/15257'
      single_form.name.should             eq 'blue_cross_blue_shield_georgia_general'
      single_form.description.should      eq 'Anthem Non-Preferred Medications Request Form'
      single_form.directions.should       eq 'Anthem Prior Authorization Form for Non-Preferred Medications Request '
      single_form.request_form_id.should  eq 'blue_cross_blue_shield_georgia_general_15257'
      single_form.thumbnail_url.should    eq 'https://navinet.covermymeds.com/forms/pdf/thumbs/90/blue_cross_blue_shield_georgia_general_15257.jpg'
    end
  end
end
