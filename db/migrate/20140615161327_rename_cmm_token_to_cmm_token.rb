class RenameCmmTokenToCmmToken < ActiveRecord::Migration
  def change
    rename_column :requests, :cmmToken, :cmm_token
  end
end
