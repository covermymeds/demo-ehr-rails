require 'rails_helper'

describe 'Registering Credentials with CMM' do
  fixtures :all
  let(:doctor_login) { "/login/doctor" }
  let(:staff_login) { "/login/staff" }

  let(:user) { users(:doctor) }

  before do
    login_user(user)
  end

  context 'from the user edit page' do
    it 'allows the prescriber to register their credentials' do
      visit edit_user_path(user)
      fill_in('Npi', with: '1234567890')
      fill_in('Fax', with: '1-800-555-5555')
      check('Register with CMM')
      click_button('Update User')

      visit edit_user_path(user)
      expect(page).to have_checked_field('Register with CMM', disabled: true)
    end
  end
end
