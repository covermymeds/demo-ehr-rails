class User < ActiveRecord::Base
  # this is a demo app; you probably don't want to hard-code YOUR user ids.
  FLEMING = 1
  STAFF = 2
  
  validates :name, presence: true, uniqueness: true

  def prescriber?
    valid_npi?
  end

  def valid_npi?
    npi && npi.size == 10 && npi =~ /^\d+$/
  end
end
