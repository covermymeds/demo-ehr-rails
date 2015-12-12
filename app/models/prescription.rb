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
  ].freeze

  def self.check_pa_required?(drug_name)
    return false if drug_name.nil?
    ['banana', 'chocolate', 'abilify'].include?( drug_name.downcase )
  end

  def self.check_autostart?(drug_name)
    return false if drug_name.nil?
    ['chocolate'].include?( drug_name.downcase )
  end

  def script
    "#{drug_name} #{frequency}, Quantity: #{quantity}, Refills: #{refills.to_s}"
  end
end
