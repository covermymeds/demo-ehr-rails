class AddAutostartToPrescription < ActiveRecord::Migration
  def change
    add_column :prescriptions, :autostart, :boolean, default: false
  end
end
