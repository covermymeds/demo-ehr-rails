class User < ActiveRecord::Base
  scope :doctors, -> { where(role: Role.doctor) }
  scope :staff, -> { where(role: Role.staff) }

  validates :role_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: { message: "Prescribers must have a last name" }, if: :prescriber?
  validates :npi, presence: { message: "Prescribers must have an npi" }, if: :prescriber?
  validate :valid_npi?, if: :prescriber?

  belongs_to :role
  has_many :pa_requests

  def self.find_demo_user_by_role(role_description)
    case role_description.to_s.downcase
    when Role::DOCTOR
      demo_doctor
    when Role::STAFF
      demo_staff
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def display_name
    "#{role == Role.doctor ? 'Dr. ' : ''}#{first_name} #{last_name}"
  end

  def prescriber?
    role == Role.doctor
  end

  private

  def valid_npi?
    unless npi && npi.size == 10 && npi =~ /^\d+$/
      errors.add(:valid_npi, "must be 10 digits")
    end
  end

  def self.demo_doctor
    User.joins(:role).where(last_name: 'Fleming').where('roles.description = ?', Role::DOCTOR).first
  end

  def self.demo_staff
    User.joins(:role).where(first_name: 'Staff').where('roles.description = ?', Role::STAFF).first
  end
end
