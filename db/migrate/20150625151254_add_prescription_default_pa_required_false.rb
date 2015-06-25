class AddPrescriptionDefaultPaRequiredFalse < ActiveRecord::Migration
  def change
    change_column :prescriptions, :pa_required, :boolean, default: false
  end
end
