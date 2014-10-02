class AddFormularyStatusToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :formulary_status, :string
  end
end
