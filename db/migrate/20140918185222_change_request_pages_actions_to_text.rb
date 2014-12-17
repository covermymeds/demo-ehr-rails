class ChangeRequestPagesActionsToText < ActiveRecord::Migration
  def change
    change_column :pa_requests, :request_pages_actions, :text, limit: nil
  end
end
