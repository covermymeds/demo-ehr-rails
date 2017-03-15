class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :cancel_registration]
  before_action :set_roles, only: [:new, :edit, :update]

  def login
    if params[:id]
      login_with_id!
    elsif params[:role_description]
      login_with_role!
    end
  end

  def logout
    session['user_id'] = nil
    @current_user = nil
    redirect_to root_url
  end

  def edit
  end

  def new
    @user = User.new
  end

  def update
    respond_to do |format|
      if @user.update(user_params) &&
         CmmRegistrar.new(user: @user).handle_registration
        format.html { redirect_to root_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html do
          flash[:error] = 'Unable to register provider. Check the NPI. It must start with 9 in this demo application.'
          render :edit
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel_registration
    client = CoverMyMeds.default_client
    client.delete_credential(@user.npi)
    @user.update_attributes(registered_with_cmm: false)
    redirect_to edit_user_path(@user),
                notice: 'User registration with CMM has been cancelled'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_roles
    @roles = Role.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :npi, :role_id, :email, :practice_name,
                                 :practice_phone_number, :practice_street_1, :practice_street_2,
                                 :practice_city, :practice_state, :practice_zip, :registered_with_cmm,
                                 credentials_attributes: [:id, :fax, :_destroy])
  end

  def login_with_id!
    user = User.find_by_id(params[:id])
    if user && login_user!(user)
      flash_message("Logged in as #{user.display_name}")
    else
      flash_message('Login failed.  User not found')
    end
    redirect_to home_url
  end

  def login_with_role!
    user = User.joins(:role).where('roles.description = ?', params[:role_description]).first
    if user && login_user!(user)
      flash_message("Logged in as #{user.display_name}")
    else
      flash_message('Demo account not found.  Try resetting the database.')
    end
    redirect_to home_url
  end

  def login_user!(user)
    session['user_id'] = user.id
    @current_user ||= user
  end
end
