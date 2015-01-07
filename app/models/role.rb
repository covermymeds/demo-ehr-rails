class Role < ActiveRecord::Base
  def self.doctor
    find_by_description 'Doctor'
  end

  def self.staff
    find_by_description 'Staff'
  end
end
