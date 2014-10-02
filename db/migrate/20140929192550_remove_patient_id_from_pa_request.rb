class RemovePatientIdFromPaRequest < ActiveRecord::Migration
  def change
    remove_column :pa_requests, :patient_id
  end
end
