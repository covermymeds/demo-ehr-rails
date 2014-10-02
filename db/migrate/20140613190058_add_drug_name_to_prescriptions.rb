class AddDrugNameToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :drug_name, :string
  end
end
