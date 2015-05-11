require 'rails_helper'

describe CredentialsController, type: :controller do
  fixtures :users
  let!(:user)        { users(:doctor) }
  let(:doctor_login) { '/login/doctor' }

  before do
    session[:user_id] = user.id
  end

  describe 'POST create' do
    let(:do_request) { post :create, user_id: user.id, credential: { fax: '1-855-555-5555' } }
    before do
      expect_any_instance_of(CoverMyMeds::Client).to receive(:create_credential).with(npi: user.npi, callback_url: cmm_callbacks_url, callback_verb: 'POST', fax_numbers: '1-855-555-5555', contact_hint: user.contact_hint).and_return({})
    end

    it 'sets the user' do
      do_request
      expect(assigns(:user)).to eq(user)
    end

    it 'redirects to the edit user action' do
      expect(do_request).to redirect_to edit_user_url(user)
    end
  end

  describe 'DELETE destroy' do
    let!(:credential) { user.credentials.create(fax: '1-855-333-4444') }
    let(:do_request) { delete :destroy, user_id: user.id, id: credential.id }

    it 'sets the user' do
      do_request
      expect(assigns(:user)).to eq(user)
    end

    it 'redirects to the edit user action' do
      expect(do_request).to redirect_to edit_user_url(user)
    end
  end
end
