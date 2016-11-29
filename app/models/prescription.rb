class Prescription < ActiveRecord::Base
  belongs_to :patient, inverse_of: :prescriptions
  belongs_to :pharmacy, inverse_of: :prescriptions
  has_many :pa_requests, dependent: :destroy, inverse_of: :prescription

  validates :drug_number, format: {with: /[0-9]+/ , message: 'Drug Number is invalid'}
  validates_presence_of :patient

  default_scope { order(date_prescribed: :desc) }

  scope :active, -> { where(active: true) }

  FREQUENCIES = [
    ['qD - EVERY DAY', 'qD'],
    ['BID - TWICE A DAY', 'BID'],
    ['TID - THREE A DAY', 'TID'],
    ['QID - FOUR A DAY', 'QID'],
    ['PRN - AS NEEDED', 'PRN'],
    ['UD - AS DIRECTED', 'UD']
  ].freeze

  def initiate_pa current_user
    pa_request = pa_requests.build(
      user: current_user,
      state: patient.state,
      urgent: false)

    begin
      response = CoverMyMeds.default_client.create_request RequestConfigurator.new(pa_request).request

      pa_request.set_cmm_values(response)
      pa_request.save
    rescue CoverMyMeds::Error::HTTPError => e
      false
    end
  end

  def days_supply
    case frequency
    when 'qD'
      quantity
    when 'BID'
      (quantity / 2).ceil
    when 'TID'
      (quantity / 3).ceil
    when 'QID'
      (quantity / 4).ceil
    else 
      quantity
    end
  end

  def quantity_unit_of_measure
    "C48480" # Capsule    
  end

  def diagnosis9
    "800.14"
  end

  def diagnosis10
    "K80.67"
  end

  def script
    "#{drug_name} #{frequency}, Quantity: #{quantity}, Refills: #{refills.to_s}"
  end

  private

end
