class RenameCallbackToCmmcallback < ActiveRecord::Migration
  def change
    rename_table :callbacks, :cmm_callbacks
  end
end
