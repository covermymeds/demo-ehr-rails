class MoveRegistedWithCmmToUser < ActiveRecord::Migration
  def change
    remove_column :credentials, :registered_with_cmm, :boolean
    add_column :users, :registered_with_cmm, :boolean, default: false
  end
end
