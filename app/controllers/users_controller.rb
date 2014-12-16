class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def login
    session["user_id"] = params["id"]
    @current_user ||= User.find_by_id(session["user_id"])
    redirect_to root_url
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
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
      params.require(:user).permit(:name, :npi)
    end
end
