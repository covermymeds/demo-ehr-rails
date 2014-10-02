class AddOutcomeToPaRequest < ActiveRecord::Migration
  def change
    add_column :pa_requests, :cmm_outcome, :string
  end
end
