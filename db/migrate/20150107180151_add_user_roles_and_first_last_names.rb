class AddUserRolesAndFirstLastNames < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :description, null: false
    end
    change_table :users do |t|
      t.rename :name, :first_name
      t.string :last_name
      t.references :role, index: true
    end
  end
end
