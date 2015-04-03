require 'rails_helper'

describe UsersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { first_name: "Test", last_name: "McTester", npi: "3141592654", role_id: 1}
  }

  let(:invalid_attributes) {
    { first_name: nil, npi: "12345", role_id: nil }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET login/:id" do
    it "logs in the desired user" do
      expect(controller.current_user).to be_nil
      user = User.create! valid_attributes
      get :login, {id: user.to_param}, valid_session
      expect(session["user_id"].to_i).to eq(user.id)
      expect(controller.current_user).to eq(user)
    end
  end

  describe "GET logout" do
    it "logs out the current user" do
      expect(controller.current_user).to be_nil
      user = User.create! valid_attributes
      get :login, {id: user.to_param}, valid_session
      expect(session["user_id"].to_i).to eq(user.id)
      expect(controller.current_user).to eq(user)

      get :logout, {}, valid_session
      expect(session["user_id"]).to be_nil
      expect(controller.current_user).to be_nil
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      get :edit, {id: user.to_param}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      context "when not registering with CMM" do
        let(:new_attributes) do
          { first_name: 'Dr. Robert Liston', npi: '4242424242', fax: '18001234567', registered_with_cmm: false  }
        end
        let!(:user) {User.create! valid_attributes}

        it "updates the requested user" do
          put :update, {id: user.to_param, user: new_attributes}, valid_session
          user.reload
          expect(assigns(:user)).to eq(user)
        end

        it "assigns the requested user as @user" do
          put :update, {id: user.to_param, user: valid_attributes}, valid_session
          expect(assigns(:user)).to eq(user)
        end

        it "redirects to the root" do
          put :update, {id: user.to_param, user: valid_attributes}, valid_session
          expect(response).to redirect_to(root_path)
        end

        it 'should not call the credentials api' do
          expect_any_instance_of(CoverMyApi::Client).to_not receive(:create_credential)
          put :update, {id: user.to_param, user: valid_attributes}, valid_session
        end
      end
      context "when registering with CMM" do
        let(:new_attributes) do
          { first_name: 'Dr. Robert Liston', npi: '4242424242', fax: '18001234567', registered_with_cmm: true  }
        end
        let(:user) {User.create! valid_attributes}

        it "calls the credentials api" do
          expect_any_instance_of(CoverMyApi::Client).to receive(:create_credential).with('4242424242', '18001234567')
          put :update, {id: user.to_param, user:new_attributes}, valid_session
        end
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        user = User.create! valid_attributes
        put :update, {id: user.to_param, user: invalid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = User.create! valid_attributes
        put :update, {id: user.to_param, user: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end



end
