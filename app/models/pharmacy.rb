class Pharmacy < ActiveRecord::Base
  has_many :prescriptions, inverse_of: :pharmacy

  def display_name
    "#{name} - #{street}, #{city}, fax: #{fax}"
  end

end
