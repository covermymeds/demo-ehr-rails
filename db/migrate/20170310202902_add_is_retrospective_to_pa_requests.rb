class AddIsRetrospectiveToPaRequests < ActiveRecord::Migration
  def change
    add_column :pa_requests, :is_retrospective, :boolean, default: false
  end
end
