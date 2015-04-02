class AddRegistedWithCmmToUsers < ActiveRecord::Migration
  def change
    add_column :users, :registered_with_cmm, :boolean
  end
end
