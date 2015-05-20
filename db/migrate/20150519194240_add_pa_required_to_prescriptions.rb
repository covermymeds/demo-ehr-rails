class AddPaRequiredToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :pa_required, :boolean, default: false
  end
end
