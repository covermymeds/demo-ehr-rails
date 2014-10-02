class CreatePharmacies < ActiveRecord::Migration
  def change
    create_table :pharmacies do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :fax
      t.string :phone

      t.timestamps
    end
  end
end
