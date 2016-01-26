require 'rails_helper'

describe 'Credential Management' do
  fixtures :all
  let(:doctor_login) { "/login/doctor" }
  let(:staff_login) { "/login/staff" }

  let(:user) { users(:doctor) }

  before do
    login_user(user)
    response = JSON.parse(File.read('spec/fixtures/credentials_post_response.json'))
    stub_request(:post, /https:\/\/(\S*):(\S*)@api.covermymeds.com\/prescribers\/credentials\/\?v=1/ )
      .to_return(body: response.to_json)
  end

  after do
    logout_user(user)
  end

  context 'when adding a new credential', js: true do
    it 'allows the prescriber to register a credential' do
      visit edit_user_path(user)

      check('I would like to receive PAs started at the pharmacy for the below fax numbers.')
      click_link('Add Fax')

      find_field('Fax').click
      find_field('Fax').send_keys '614-555-5555'

      click_button 'Update User'
      visit edit_user_path(user)
      expect(page).to have_field('Fax')
      expect(find_field('Fax').value).to eq('614-555-5555')
    end
  end

  context 'when deleting an existing credential', js: true do
    let!(:credential) { Credential.create!(fax: '8005554444', user_id: user.id) }
    it 'allows the prescriber to delete a credential' do
      visit edit_user_path(user)
      expect(find_field('Fax').value).to eq('8005554444')
      click_link 'Remove Fax'
      click_button 'Update User'
      visit edit_user_path(user)
      expect(page).to have_no_field('Fax')
    end
  end
end
