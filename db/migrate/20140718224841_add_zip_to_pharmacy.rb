class AddZipToPharmacy < ActiveRecord::Migration
  def change
    add_column :pharmacies, :zip, :string
  end
end
