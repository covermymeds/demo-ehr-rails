class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :npi

      t.timestamps
    end
    
    add_index :users, :name, unique: true
    add_index :users, :npi, unique: true
  end
end
