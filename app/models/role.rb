class Role < ActiveRecord::Base
  DOCTOR = 'doctor'.freeze
  STAFF = 'staff'.freeze

  def self.doctor
    find_by_description DOCTOR
  end

  def self.staff
    find_by_description STAFF
  end
end
