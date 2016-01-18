require 'rails_helper'
require 'spec_helper'

describe 'eHR Example App' do
  fixtures :all
  let(:doctor_login) { "/login/doctor" }
  let(:staff_login) { "/login/staff" }
  let(:staff) { "Staff" }
  let(:doctor) { "Dr. Alexander Fleming" }
  let(:stubbed_pa_request) do
      '{
      "requests": [
        {
          "memo": "system-specific information",
          "id": "PF6FK9",
          "api_id": "1vd9o4427lyi0ccb2uem",
          "is_epa": false,
          "state": "OH",
          "thumbnail_urls": [
            "https://www.covermymeds.com/async/thumbnail/?request=PF6FK9&mode=plan"
          ],
          "pdf_url": "https://www.covermymeds.com/request/send/PF6FK9/",
          "html_url": "https://www.covermymeds.com/request/view/PF6FK9",
          "plan_outcome": "Favorable",
          "workflow_status": "Archived",
          "href": "https://api.covermymeds.com/requests/PF6FK9",
          "patient": {
            "first_name": "Susan",
            "last_name": "Denmark"
          },
          "prescriber": {
            "npi": null,
            "first_name": "",
            "last_name": ""
          },
          "prescription": {
            "name": "Boniva 2.5MG tablets"
          },
          "created_at": "2014-02-21T22:48:40Z",
          "tokens": [
            {
              "id": "gq9vmqai2mkwewv1y55x",
              "request_id": "PF6FK9",
              "href": "https://api.covermymeds.com/requests/tokens/gq9vmqai2mkwewv1y55x",
              "html_url": "https://www.covermymeds.com/request/view/PF6FK9?token_id=gq9vmqai2mkwewv1y55x",
              "pdf_url": "https://www.covermymeds.com/request/send/PF6FK9?token_id=gq9vmqai2mkwewv1y55x",
              "thumbnail_url": "https://www.covermymeds.com/async/thumbnail/?mode=plan&request=PF6FK9&token_id=gq9vmqai2mkwewv1y55x"
            }
          ]
        }
      ]
    }'
    end

    let(:stubbed_drug_response) do
      '{
  "drugs": [
    {
      "id": "131079",
      "gpi": "49270025103010",
      "sort_group": null,
      "sort_order": null,
      "name": "NexIUM",
      "route_of_administration": "OR",
      "dosage_form": "PACK",
      "strength": "10",
      "strength_unit_of_measure": "MG",
      "dosage_form_name": "packets",
      "full_name": "NexIUM 10MG packets",
      "href": "https://api.covermymeds.com/drugs/131079"
    },
    {
      "id": "175285",
      "gpi": "49270025103004",
      "sort_group": null,
      "sort_order": null,
      "name": "NexIUM",
      "route_of_administration": "OR",
      "dosage_form": "PACK",
      "strength": "2.5",
      "strength_unit_of_measure": "MG",
      "dosage_form_name": "packets",
      "full_name": "NexIUM 2.5MG packets",
      "href": "https://api.covermymeds.com/drugs/175285"
    },
    {
      "id": "070045",
      "gpi": "49270025106520",
      "sort_group": null,
      "sort_order": null,
      "name": "NexIUM",
      "route_of_administration": "OR",
      "dosage_form": "CPDR",
      "strength": "20",
      "strength_unit_of_measure": "MG",
      "dosage_form_name": "dr capsules",
      "full_name": "NexIUM 20MG dr capsules",
      "href": "https://api.covermymeds.com/drugs/070045"
    }]}'
    end

  let(:chocolate_stubbed_drug_response) do
      '{
  "drugs": [
    {
      "id": "095553",
      "gpi": "98330000000900",
      "sort_group": null,
      "sort_order": null,
      "name": "Chocolate Flavor",
      "route_of_administration": "XX",
      "dosage_form": "LIQD",
      "strength": "",
      "strength_unit_of_measure": "",
      "dosage_form_name": "liquid",
      "full_name": "Chocolate Flavor liquid",
      "href": "https://api.covermymeds.com/drugs/095553"
    }]}'
  end

  it 'should have directions at the root' do
    visit(root_path)
    expect(page).to have_content("Let's pretend that this is your EHR...")
  end

  # Test all of the nav links
  describe 'when navigating the site via nav bar' do

    before(:each) do
      visit '/logout'
    end

    it 'should navigate to the patients view', js: true do
      click_link('Patients')
      expect(page).to have_content('Patients')
    end

    it 'should navigate to the Your EHR view', js: true do
      visit '/patients' # To test the home link visit another page besides the home page
      click_link('Your EHR')
      expect(page).to have_content("Let's pretend that this is your EHR...")
    end

    it 'should navigate to the dashboard view', js: true do
      stub_request(:post, "https://#{ENV['CMM_API_KEY']}:#{ENV['CMM_API_SECRET']}@api.covermymeds.com/requests/search/?token_ids%5B%5D=random_token&v=1").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'0', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => stubbed_pa_request, :headers => {})
      click_link('Prior Authorizations')
      click_link('Task List')
      expect(page).to have_content('Your Prior Auth Dashboard')
    end

    it 'should navigate to the new prior auth view directly', js:true do
      click_link('Prior Authorizations')
      click_link('New PA Request')
      expect(page).to have_content('New PA Request')
    end

    it 'should navigate to the new prior auth view', js: true do
      prescriptions(:prescriptions_Amber).update_attribute(:pa_required, true)
      click_link('Patients')
      expect(page).to have_content('Patients')
      # Amber has a prescription
      page.find('#patients-list > table > tbody > tr:nth-child(3) > td:nth-child(2) > a').click

      expect(page).to have_content('Prescriptions')

      find('#start_pa_request', match: :first).click
      expect(page).to have_content('New PA Request')
    end

    it 'should navigate to the contact cmm view', js: true do
      click_link('Prior Authorizations')
      click_link('Contact CoverMyMeds')
      expect(page).to have_content('For assistance using CoverMyMeds')
    end

    context 'when using the Resources menu' do

      it 'defaults to the custom UI', js: true do
        click_link ('Resources') 
        expect(find_link('Use CoverMyMeds Request Page')[:href]).to match(/toggle_ui/)
      end

      it 'should navigate to the api documentation', js: true do
        click_link ('Resources') 
        expect(find_link('API Documentation')[:href]).to match("/api")
      end

      it 'should display the source code when asked', js: true do
        click_link ('Resources') 
        expect(find_link('Source Code')[:href]).to match("/code")
      end

      it 'should reset the database when asked', js: true do
        click_link ('Resources') 
        response = Hashie::Mash.new(JSON.parse(File.read('spec/fixtures/created_pa.json')))
        allow_any_instance_of(CoverMyMeds::Client).to receive(:create_request).and_return response
        click_link('Reset Database')
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content('Database has been reset')
      end

      it 'should navigate to the callbacks view', js: true do
        click_link ('Resources') 
        click_link('Callbacks')
        expect(page).to have_content('Listing callbacks')
      end
    end

    it 'should navigate to the dashboard view from staff login', js: true do
      stub_request(:post, "https://#{ENV['CMM_API_KEY']}:#{ENV['CMM_API_SECRET']}@api.covermymeds.com/requests/search/?token_ids%5B%5D=random_token&v=1").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'0', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => stubbed_pa_request, :headers => {})
      visit '/logout'
      click_link "Sign in..."
      click_link "staff_login"
      expect(page).to have_content('Your Prior Auth Dashboard')
    end

    it 'should navigate to the patient list from doctor login', js: true do
      visit '/logout'
      click_link "Sign in..."
      click_link "dr_login"
      expect(page).to have_content('Patients')
    end
  end

  # Test everything a user can do on the patients index
  describe 'patients index workflow' do

    before(:each) do
      visit '/patients'
    end

    it 'should allow accessing patients index directly' do
      expect(page).to have_content('Patients')
    end

    it 'clicking add patient should direct user to patients new view' do
      click_link('Add patient')
      expect(page).to have_content('First Name')
    end

    it 'should create ten default patients by default', js: true do
      expect(page).to have_selector('.table')
      expect(page).to have_css('.table tr.patients', count: 10)
    end

    describe 'clicking a patient' do
      context 'when the user is a doctor' do
        before do
          visit doctor_login
          visit '/patients'
        end

        it "should navigate to the new prescription form if patient is clicked with no prescriptions assigned" do
          click_link('Mike Miller 10/01/1971 OH')
          expect(page).to have_content 'Prescription -'
        end
      end

      context "when the user is staff" do
        before do
          visit staff_login
          visit '/patients'
        end

        it "should navigate to the patient show page if patient is clicked with no prescriptions assigned" do
          click_link('Mike Miller 10/01/1971 OH')
          expect(page).to have_content 'Edit Patient'
        end
    
        it 'should delete a patient if remove button is clicked', js: true do
          within '.table' do
            click_link('X', match: :first)
          end
          expect(page).to have_css('.table tr.patients', count: 9)
        end
      end
    end

  end

  describe 'patients add workflow' do
    it 'should create a patient' do
      visit '/patients/new'

      within_fieldset 'patient' do
        fill_in('patient_first_name', with: 'Example')
        fill_in('patient_last_name', with: 'Patient')
        fill_in('Birthdate', with: '01/01/1970')

        find(:xpath, '//body').click # Use this to deactivate the datepicker
        select('Ohio', from: 'State')
      end

      within_fieldset 'insurance' do
        fill_in('BIN', with:'111111')
        fill_in('PCN', with: 'SAMP001')
        fill_in('Group Rx ID', with: 'NOTREAL')
      end

      click_on('Create')
      expect(page).to have_content('Patient created successfully.')
    end
  end

  describe 'adding a prescription' do
    let(:drug_name) { 'Nexium' }
    let(:full_drug_name) { 'NexIUM 2.5MG packets' }
    let(:pa_required) { false }
    let(:pa_required_drug_name) { 'Chocolate' }
    let(:pa_required_full_drug_name) { 'Chocolate Flavor Liquid' }
    before do
      visit doctor_login
      visit '/patients'
      page.find('#patients-list > table > tbody > tr:nth-child(3) > td:nth-child(2) > a').click
      click_link('Add Prescription')
      stub_indicators(drug_name, pa_required)
      stub_drugs(drug_name, stubbed_drug_response)
    end

    it 'should add a medication to a patient', js: true do
      # Find a drug
      fill_autocomplete 'prescription_drug_name', with: drug_name, select: full_drug_name
      
      fill_in "prescription_quantity", with: '1'

      click_on('Create Prescription')

      visit(patients_path)
      page.find('#patients-list > table > tbody > tr:nth-child(3) > td:nth-child(2) > a').click
      expect(page).to have_selector('#patient-show')
    end

    describe 'formulary service' do
      before do
        stub_create_pa_request!
        stub_indicators(drug_name, pa_required)
        fill_autocomplete 'prescription_drug_name', with: drug_name, select: full_drug_name
      end

      context 'drug requires a PA' do
        let(:drug_name) { 'Chocolate' }
        let(:full_drug_name) { 'Chocolate Flavor liquid' }
        let(:stubbed_drug_response) { chocolate_stubbed_drug_response }
        let(:pa_required) { true }

        xit 'checks the PA Required checkbox', js: true do
          expect(find('#prescription_pa_required')).to be_checked
        end

        xit 'starts a PA', js: true do
          click_on('Create Prescription')
          expect(page).to have_content("Your prior authorization request was successfully started.")
        end
      end

      context 'drug does not require a PA' do
        let(:pa_required) { false }

        xit 'does not check the pa_required box', js: true do
          expect(find('#prescription_pa_required')).to_not be_checked
        end

        xit 'does not create a PA', js: true do
          click_on('Create Prescription')
          expect(page).to have_content("PA Not Required")
        end
      end
    end
  end
end
