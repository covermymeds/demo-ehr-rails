class User < ActiveRecord::Base
  scope :doctors, -> { where(role: Role.doctor) }
  scope :staff, -> { where(role: Role.staff) }

  validates :role_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: { message: 'Prescribers must have a last name' }, if: :prescriber?
  validates_presence_of :npi, message: 'Prescribers must have an npi', if: :prescriber?
  validate :valid_npi?, if: :prescriber?
  validate :validate_credentials

  belongs_to :role
  has_many :pa_requests, inverse_of: :user
  has_many :credentials, inverse_of: :user

  accepts_nested_attributes_for :credentials, reject_if: :all_blank, allow_destroy: true
  has_many :alerts

  def display_name
    "#{salutation}#{first_name} #{last_name}"
  end

  def salutation
    (role == Role.doctor ? 'Dr. ' : '')
  end

  def prescriber?
    role == Role.doctor
  end

  def contact_hint
    {
      email: email,
      full_name: display_name,
      practice: {
        name: practice_name,
        phone_number: practice_phone_number,
        address: {
          street_1: practice_street_1,
          street_2: practice_street_2,
          city: practice_city,
          state: practice_state,
          zip: practice_zip
        }
      }
    }
  end

  private

  def cmm_register(credential)
    client = CoverMyMeds.default_client
    client.create_credential(npi: npi,
                             callback_url: '/cmm_callbacks.json',
                             callback_verb: 'POST',
                             fax_numbers: credential.fax,
                             contact_hint: contact_hint)
  end

  def valid_npi?
    unless npi && npi.size == 10 && npi =~ /^\d+$/
      errors.add(:valid_npi, 'must be 10 digits')
    end
  end

  def validate_credentials
    if registered_with_cmm && credentials.reject(&:marked_for_destruction?).blank?
      errors.add(:credentials, 'You must have at least one fax number if registering your NPI with CoverMyMeds.')
    end
  end
end
