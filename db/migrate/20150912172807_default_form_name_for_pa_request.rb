class DefaultFormNameForPaRequest < ActiveRecord::Migration
  def change
    change_column :pa_requests, :form_name, :string, :default => "None Chosen"
  end
end
