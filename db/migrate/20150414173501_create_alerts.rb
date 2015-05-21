class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :user_id
      t.text :message
      t.timestamps
    end

    add_index :alerts, :user_id, unique: false
  end
end
