class Prescription < ActiveRecord::Base
  belongs_to :patient, inverse_of: :prescriptions
  belongs_to :pharmacy, inverse_of: :prescriptions
  has_many :pa_requests, dependent: :destroy, inverse_of: :prescription

  validates :drug_number, format: {
    with: /[0-9]+/, message: 'Drug number must be a DDID or NDC'
  }
  validates_presence_of :patient

  default_scope { order(date_prescribed: :desc) }

  scope :active, -> { where(active: true) }

  FREQUENCIES = [
    ['qD - EVERY DAY',    'qD'],
    ['BID - TWICE A DAY', 'BID'],
    ['TID - THREE A DAY', 'TID'],
    ['QID - FOUR A DAY',  'QID'],
    ['PRN - AS NEEDED',   'PRN'],
    ['UD - AS DIRECTED',  'UD']
  ].freeze

  PERDAY = {
    qd:  1,
    bid: 2,
    tid: 3,
    qid: 4
  }.freeze


  def initiate_pa(current_user)
    pa_request = pa_requests.build(user: current_user,
                                   state: patient.state,
                                   urgent: false)
    response = CoverMyMeds
               .default_client
               .create_request RequestConfigurator.new(pa_request).request

    pa_request.set_cmm_values(response).save
  rescue CoverMyMeds::Error::HTTPError => e
    logger.error("Unable to create PA request: #{e.message}")
    false
  end

  def days_supply
    return quantity if frequency.nil?
    per_day = PERDAY.fetch(frequency.downcase.to_sym, 1)
    (quantity / per_day)
  end

  def quantity_unit_of_measure
    'C48480' # Capsule from Quantity Unit Of Measure NCPDP codes
  end

  def diagnosis9
    '800.14'
  end

  def diagnosis10
    'K80.67'
  end

  def script
    "#{drug_name} #{frequency}, Quantity: #{quantity}, Refills: #{refills}"
  end
end
