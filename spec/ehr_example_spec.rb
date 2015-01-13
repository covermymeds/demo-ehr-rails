require 'rails_helper'

describe 'eHR Example App' do
  fixtures :all

  # Test all of the nav links
  describe 'navigating the site via nav bar' do
    fixtures :patients, :prescriptions

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
      expect(page).to have_content('Lets pretend that this is your EHR...')
    end

    it 'should navigate to the dashboard view', js: true do
      click_link('Prior Authorizations')
      click_link('Dashboard')
      expect(page).to have_content('Your Prior Auth Dashboard')
    end

    it 'should navigate to the new prior auth view directly', js:true do
      click_link('Prior Authorizations')
      click_link('New PA Request')
      expect(page).to have_content('New PA Request')
    end

    it 'should navigate to the new prior auth view', js: true do
      click_link('Patients')
      expect(page).to have_content('Patients')

      # Amber has a prescription
      page.find('#patients-list > table > tbody > tr:nth-child(2) > td:nth-child(2) > a').click

      expect(page).to have_content('Prescriptions')

      find('#start_pa_request', match: :first).click
      expect(page).to have_content('New PA Request')
    end

    it 'should navigate to the contact cmm view' do
      click_link('Prior Authorizations')
      click_link('Contact CoverMyMeds')
      expect(page).to have_content('For assistance using CoverMyMeds')
    end

    it 'should navigate to the api documentation' do
      click_link('Resources')
      click_link('API Documentation')
      expect(page).to have_title('API Reference')
    end

    it 'should navigate to the dashbaord view from button' do
      click_link('Start Task List Workflow')
      expect(page).to have_content('Your Prior Auth Dashboard')
    end

    it 'should navigate to the patient list from button' do
      click_link('Start e-Prescribing Workflow')
      expect(page).to have_content('Patients')
    end

    it 'should change api environments from the link' do
      click_link('Resources')
      expect(page).to have_content('currently using production')
      click_link('change-api-env')
      click_link('Resources')
      expect(page).to have_content('currently using integration')
    end
  end

  # Test everything a user can do on the patients index
  describe 'patients index workflow' do
    fixtures :patients, :prescriptions

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

    it 'should create ten default patients by default' do
      expect(page).to have_selector('.table')
      expect(page).to have_css('.table tr.patients', count: 10)
    end

    it 'should navigate to new prescription form if patient is clicked with no prescriptions assigned', failed: true do
      click_link('Mike Miller 10/01/1971 OH')
      expect(page).to have_content('Prescription -')
    end

    it 'should delete a patient if remove button is clicked' do

      within '.table' do
        click_link('X', match: :first)
      end
      expect(page).to have_css('.table tr.patients', count: 9)
    end

  end

  describe 'patients add workflow' do
    fixtures :patients, :prescriptions

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

    it 'should add a medication to a patient', js: true do
      visit '/patients'

      # Find the first patient and click on them
      page.find('#patients-list > table > tbody > tr:nth-child(2) > td:nth-child(2) > a').click
      click_link('Add Prescription')

      # Find a medication
      find('#s2id_prescription_drug_number').click
      find('.select2-input').set('Nexium')
      expect(page).to have_selector('.select2-result-selectable')
      within '.select2-results' do
        find('li:first-child').click
      end
      select "CVS - 670 N. High St., Columbus, fax: 555-555-5555", from: "prescription_pharmacy_id"

      click_on('Save')

      # Back on the patient page
      expect(page).to have_selector('#patient-show')

      # start the prior auth
#      click_on('Start')

      # check('request', match: :first)

      # click_on('Next')

      # # Should be on pharmacy list page
      # expect(page).to have_selector('#pharmacies-list')
      # click_on('Finish')

      # expect(page).to have_content('Lets pretend that this is your EHR...')
    end

    it 'should navigate patient show if patient name is clicked and patient has prescription assigned', js: true do
      visit '/'
      click_link('Patients')
      page.find('#patients-list > table > tbody > tr:nth-child(2) > td:nth-child(2) > a').click

      click_link('Add Prescription')

      # Find a drug
      find('#s2id_prescription_drug_number').click
      find('.select2-input').set('Nexium')
      expect(page).to have_selector('.select2-result-selectable')
      within '.select2-results' do
        find('li:first-child').click
      end

      click_on('Save')

      visit '/patients'
      page.find('#patients-list > table > tbody > tr:nth-child(2) > td:nth-child(2) > a').click
      expect(page).to have_content('Add Prescription')
    end

  end

  it 'should allow accessing the site root' do
    visit('/')
    expect(page).to have_content("Lets pretend that this is your EHR...")
  end

  it 'should display a help view' do
    visit('/')
    click_link('Prior Authorizations')
    click_link('Contact CoverMyMeds')
    expect(page).to have_content('For assistance using CoverMyMeds')
  end

  it 'should display the source code when asked' do
    visit('/')
    click_link('Resources')
    click_link('Source Code')
    expect(page).to have_content('Reference implementation of an EHR integration with CoverMyMeds, written in Ruby on Rails.')
  end

end

