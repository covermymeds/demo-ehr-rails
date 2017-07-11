class Pharmacy < ActiveRecord::Base
  has_many :prescriptions, inverse_of: :pharmacy

  def display_name
    "#{name} - #{street}, #{city}, fax: #{fax}"
  end

  def to_pharmacy_hash
    {
      name: name,
      fax_number: fax,
      phone_number: phone,
      address: {
        street_1: street,
        city: city,
        state: state,
        zip: zip
      }
    }
  end

end
