class AddFaxToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fax, :string
  end
end
