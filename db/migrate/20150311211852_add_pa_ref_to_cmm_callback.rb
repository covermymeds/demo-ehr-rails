class AddPaRefToCmmCallback < ActiveRecord::Migration
  def change
    add_column :cmm_callbacks, :pa_request_id, :integer
    add_index :cmm_callbacks, :pa_request_id
  end
end
