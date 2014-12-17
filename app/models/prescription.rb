class Prescription < ActiveRecord::Base
  belongs_to :patient
  belongs_to :pharmacy, inverse_of: :prescriptions
  has_many :pa_requests, dependent: :destroy

  validates :drug_number, format: {with: /[0-9]+/ , message: 'Drug Number is invalid'}
  
  scope :active, -> { where(active: true) }
  
  FREQUENCIES = [
    ['qD - EVERY DAY', 'qD'],
    ['BID - TWICE A DAY', 'BID'],
    ['TID - THREE A DAY', 'TID'],
    ['QID - FOUR A DAY', 'QID'],
    ['PRN - AS NEEDED', 'PRN'],
    ['UD - AS DIRECTED', 'UD']
  ]

  FORMULARY_STATUSES = [
    "Off formulary", 
    "Tier 3/PA", 
    "Tier 1", 
    "Tier 2/PA"
  ]

  def script
    "#{drug_name} #{frequency}, Quantity: #{quantity}, Refills: #{refills.to_s}"
  end
end
