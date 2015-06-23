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

  def pa_required?
    self.pa_required || (self.drug_name && self.drug_name.downcase.include?("banana"))
  end

  def script
    "#{drug_name} #{frequency}, Quantity: #{quantity}, Refills: #{refills.to_s}"
  end
end
