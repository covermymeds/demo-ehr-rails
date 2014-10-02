class RenameStreet2ToStreet2InPatients < ActiveRecord::Migration
  def change
    rename_column :patients, :street2, :street_2
  end
end
