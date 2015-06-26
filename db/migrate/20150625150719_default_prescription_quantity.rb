class DefaultPrescriptionQuantity < ActiveRecord::Migration
  def change
    change_column :prescriptions, :quantity, :integer, :default => 1
  end
end
