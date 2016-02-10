class AddDisplayToPaRequest < ActiveRecord::Migration
  def change
    add_column :pa_requests, :display, :boolean, default: true
  end
end
