class AddCmmIdToPaRequests < ActiveRecord::Migration
  def change
    add_column :pa_requests, :cmm_id, :string
  end
end
