require 'rails_helper'

describe 'Credential Management' do
  fixtures :all
  let(:doctor_login) { "/login/doctor" }
  let(:staff_login) { "/login/staff" }

  let(:user) { users(:doctor) }
  let(:do_request) { visit edit_user_path(user) }

  before do
    login_user(user)
  end

  after do
    logout_user(user)
  end

  context 'when adding a new credential' do
    it 'allows the prescriber to register a credential' do
      do_request
      expect(page).to have_link('Register a new Fax Number with CoverMyMeds', href: new_user_credential_path(user))

      click_link('Register a new Fax Number with CoverMyMeds')
      expect(page).to have_content('Register a new Fax Number with CMM')

      fill_in('Fax', with: '1-800-555-5555')
      click_button 'Create Credential'
      expect(page).to have_content('1-800-555-5555')
    end
  end

  context 'when deleting an existing credential' do
    let!(:credential) { Credential.create!(fax: '1-800-555-4444', user_id: user.id) }
    it 'allows the prescriber to delete a credential' do
      do_request
      expect(page).to have_content('1-800-555-4444')
      click_link 'Remove'
      expect(page).to have_content('Fax Number removed successfully')
      expect(page).to_not have_content('1-800-555-5555')
    end
  end
end
