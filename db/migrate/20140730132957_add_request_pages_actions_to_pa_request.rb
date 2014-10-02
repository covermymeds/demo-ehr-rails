class AddRequestPagesActionsToPaRequest < ActiveRecord::Migration
  def change
    add_column :pa_requests, :request_pages_actions, :string
  end
end
