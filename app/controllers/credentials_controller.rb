class CredentialsController < ApplicationController
  before_action :set_user, only: [:new, :create, :destroy]

  def new
    @credential = @user.credentials.build
  end

  def create
    @credential = @user.credentials.build(credential_params)
    if save_credential(@credential)
      redirect_to edit_user_url(@user), notice: 'Fax number registered successfully'
    else
      render :new
    end
  end

  def destroy
    @credential = @user.credentials.find(params[:id])
    if @credential.destroy
      redirect_to edit_user_url(@user), notice: 'Fax Number removed successfully'
    end
  end

  private

  def set_user
    @user ||= User.find(params[:user_id])
  end

  def save_credential(credential)
    client = CoverMyMeds.default_client
    credential.transaction do
      credential.save
      client.create_credential(npi: @user.npi, callback_url: cmm_callbacks_url, callback_verb: 'POST', fax_numbers: credential.fax, contact_hint: @user.contact_hint)
    end
  end

  def credential_params
    params.require(:credential).permit(:fax)
  end
end
