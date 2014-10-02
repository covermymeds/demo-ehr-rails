class RenameRequestToPaRequest < ActiveRecord::Migration
  def change
    rename_table :requests, :pa_requests
  end
end
