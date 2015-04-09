class RemoveFirstNameIndexOnUsers < ActiveRecord::Migration
  def change
    remove_index "users", ["first_name"]
  end
end
