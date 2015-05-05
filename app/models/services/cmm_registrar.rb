class CmmRegistrar

  CALLBACK_VERB = 'post'.freeze
  CALLBACK_URL = '/cmm_callbacks.json'.freeze

  def initialize(user: user)
    @user = user
  end

  def handle_registration
    @user.registered_with_cmm? ? register_with_cmm : unregister_with_cmm
  end

  def register_with_cmm
    api_client.create_credential(npi: @user.npi,
                                 callback_url: CALLBACK_URL,
                                 callback_verb: CALLBACK_VERB,
                                 fax_numbers: @user.credentials.pluck(:fax),
                                 contact_hint: @user.contact_hint)
  end

  def unregister_with_cmm
    @user.update_attributes(registered_with_cmm: false)
    api_client.delete_credential(@user.npi)
  end

  private

  def api_client
    @api_client ||= ApiClientFactory.build
  end
end
