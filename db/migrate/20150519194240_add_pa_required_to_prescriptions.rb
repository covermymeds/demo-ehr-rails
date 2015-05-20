class AddStartPaToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :pa_required, :boolean
  end
end
