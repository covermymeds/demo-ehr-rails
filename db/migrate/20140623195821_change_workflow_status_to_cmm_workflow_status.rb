class ChangeWorkflowStatusToCmmWorkflowStatus < ActiveRecord::Migration
  def change
    rename_column :pa_requests, :workflow_status, :cmm_workflow_status
  end
end
