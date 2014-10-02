class AddBinPcnGroupToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :bin, :string
    add_column :patients, :pcn, :string
    add_column :patients, :group_id, :string
  end
end
