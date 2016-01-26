class AddFormNameToPaRequest < ActiveRecord::Migration
  def change
    add_column :pa_requests, :form_name, :string
  end
end
