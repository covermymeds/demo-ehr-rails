class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def login
    if params[:id]
      login_with_id!
    elsif params[:role_description]
      login_with_role!
    end
  end

  def logout
    session["user_id"] = nil
    @current_user = nil
    redirect_to root_url
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :npi, :role_id)
    end

    def login_with_id!
      # todo: use flash_message helper
      user = User.find_by_id(params[:id])
      if user && login_user!(user)
        flash_message("Logged in as #{user.display_name}")
        redirect_to home_url
      else
        flash_message("Login failed.  User not found")
        redirect_to home_url
      end
    end

    def login_with_role!
      user = User.joins(:role).where("roles.description = ?", params[:role_description]).first
      if user && login_user!(user)
        flash_message("Logged in as #{user.display_name}")
        redirect_to home_url
      else
        flash_message("Demo account not found.  Try resetting the database.")
        redirect_to home_url
      end
    end

    def login_user!(user)
      session["user_id"] = user.id
      @current_user ||= user
    end
end
