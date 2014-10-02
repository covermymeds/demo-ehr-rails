class AddPharmacyToPrescription < ActiveRecord::Migration
  def change
    add_reference :prescriptions, :pharmacy, index: true
  end
end
