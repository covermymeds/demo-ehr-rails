class Patient < ActiveRecord::Base
  has_many :prescriptions, dependent: :destroy, inverse_of: :patient
  has_many :pa_requests, through: :prescriptions, inverse_of: :patient

  validates_presence_of :first_name, :last_name, :state
  validates :date_of_birth, presence: true, format: {
    with: /[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}/, message: 'must be DD/MM/YYYY'
  }

  def full_name
    "#{first_name} #{last_name}"
  end

  def description
    "#{full_name} #{date_of_birth} #{state}"
  end

  def requests
    pa_requests.count
  end

  def to_patient_hash
    {
      first_name:            first_name,
      last_name:             last_name,
      date_of_birth:         date_of_birth,
      gender:                gender,
      member_id:             member_id,
      address: {
        city: "ADAMS MILLS",
        state: "OH",
        zip: "43821"
      }
    }
  end

  def to_payer_hash
    {
      bin: bin || '773836',
      pcn: pcn || 'MOCKPBM',
      group_id: group_id || 'ABC1'
    }.delete_if { |_, v| v.blank? }
  end

  def to_prescriber_hash
    {
      npi: "1386646586",
      first_name: "Andrew",
      last_name: "Fleming",
      clinic_name: "LAKE ARTHUR",
      fax_number: "6145555554",
      phone_number: "7256489633",
      address: {
        street_1: "370 Larry Power Road",
        city: "SHREVEPORT",
        state: "LA",
        zip: "711039632"
      }
    }
  end

  def self.create_from_callback patient, payer
    Patient.create!(
      first_name:   patient['first_name'],
      last_name:    patient['last_name'],
      date_of_birth: patient['date_of_birth'],
      street_1:     patient['address']['street_1'],
      street_2:     patient['address']['street_2'],
      city:         patient['address']['city'],
      state:        patient['address']['state'],
      zip:          patient['address']['city'],
      gender:       patient['gender'],
      phone_number: patient['phone_number'],
      bin:          payer['bin'],
      pcn:          payer['pcn'],
      group_id:     payer['group_id'],
      member_id:    patient['member_id']
    )
  end

end
