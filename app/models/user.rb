class User < ActiveRecord::Base
  # this is a demo app; you probably don't want to hard-code YOUR user ids.
  FLEMING = 1
  STAFF = 2

  scope :doctors, -> { where(role: Role.doctor) }
  scope :staff, -> { where(role: Role.staff) }

  validates :first_name, presence: true
  validates :role_id, presence: true
  belongs_to :role
  has_many :pa_requests

  def prescriber?
    valid_npi?
  end

  def valid_npi?
    npi && npi.size == 10 && npi =~ /^\d+$/
  end
end
