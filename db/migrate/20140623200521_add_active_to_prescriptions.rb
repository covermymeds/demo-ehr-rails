class AddActiveToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :active, :boolean
  end
end
