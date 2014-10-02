class AddDatePrescribedToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :date_prescribed, :datetime
  end
end
