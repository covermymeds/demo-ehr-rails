require 'rails_helper'

describe UsersController, type: :controller do
  fixtures :users

  let!(:user) { users(:doctor) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET login/:id' do
    it 'logs in the desired user' do
      expect(controller.current_user).to be_nil
      get :login, { id: user.to_param }, valid_session
      expect(session['user_id'].to_i).to eq(user.id)
      expect(controller.current_user).to eq(user)
    end
  end

  describe 'GET logout' do
    it 'logs out the current user' do
      expect(controller.current_user).to be_nil
      get :login, { id: user.to_param }, valid_session
      expect(session['user_id'].to_i).to eq(user.id)
      expect(controller.current_user).to eq(user)

      get :logout, {}, valid_session
      expect(session['user_id']).to be_nil
      expect(controller.current_user).to be_nil
    end
  end

  describe 'GET edit' do
    it 'assigns the requested user as @user' do
      get :edit, { id: user.to_param }, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PUT update' do
    # This should return the minimal set of attributes required to create a valid
    # User. As you add validations to User, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      { first_name: 'Test', last_name: 'McTester', npi: user.npi, role_id: 1 }
    end

    let(:invalid_attributes) do
      { first_name: nil, npi: '12345', role_id: nil }
    end

    describe 'with valid params' do
      context 'when not registering with CMM' do
        before do
          expect_any_instance_of(CoverMyMeds::Client).to receive(:delete_credential).with(user.npi).and_return({})
        end

        let(:new_attributes) do
          { first_name: 'Dr. Robert Liston', npi: user.npi, registered_with_cmm: false }
        end

        it 'updates the requested user' do
          put :update, { id: user.to_param, user: new_attributes }, valid_session
          user.reload
          expect(assigns(:user)).to eq(user)
        end

        it 'assigns the requested user as @user' do
          put :update, { id: user.to_param, user: valid_attributes }, valid_session
          expect(assigns(:user)).to eq(user)
        end

        it 'unregisters with cmm' do
          put :update, { id: user.to_param, user: valid_attributes }, valid_session
        end

        it 'redirects to the root' do
          put :update, { id: user.to_param, user: valid_attributes }, valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when registering with CMM' do
        it 'sends the npi and fax numbers' do
          user.credentials.create(fax: '800-555-1234')
          expect_any_instance_of(CoverMyMeds::Client).to receive(:create_credential).and_return({})
          put :update, { id: user.to_param, user: valid_attributes.merge!(registered_with_cmm: true) }, valid_session
        end
      end
    end

    describe 'with invalid params' do
      it 'assigns the user as @user' do
        put :update, { id: user.to_param, user: invalid_attributes }, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        put :update, { id: user.to_param, user: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end
end
