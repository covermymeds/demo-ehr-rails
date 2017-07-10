class AddMemberIdToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :member_id, :string
  end
end
