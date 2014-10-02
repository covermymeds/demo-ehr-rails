class AddWorkflowStatusToPaRequest < ActiveRecord::Migration
  def change
    add_column :pa_requests, :workflow_status, :string
  end
end
