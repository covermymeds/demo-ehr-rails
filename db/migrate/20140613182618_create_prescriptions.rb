class CreatePrescriptions < ActiveRecord::Migration
  def change
    create_table :prescriptions do |t|
      t.string :drug_number
      t.integer :quantity
      t.string :frequency
      t.integer :refills
      t.boolean :dispense_as_written
      t.references :patient, index: true

      t.timestamps
    end
  end
end
