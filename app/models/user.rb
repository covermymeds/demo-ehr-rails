class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  def prescriber?
    valid_npi?
  end

  def valid_npi?
    npi && npi.size == 10 && npi =~ /^\d+$/
  end
end
