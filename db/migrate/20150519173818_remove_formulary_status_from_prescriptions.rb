class RemoveFormularyStatusFromPrescriptions < ActiveRecord::Migration
  def change
    remove_column :prescriptions, :formulary_status, :string
  end
end
