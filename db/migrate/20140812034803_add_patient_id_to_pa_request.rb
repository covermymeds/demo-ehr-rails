class AddPatientIdToPaRequest < ActiveRecord::Migration
  def change
    add_column :pa_requests, :patient_id, :integer
    add_index :pa_requests, :patient_id
  end
end
