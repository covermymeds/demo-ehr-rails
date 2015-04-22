class AddContactHintFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :practice_name, :string
    add_column :users, :practice_phone_number, :string
    add_column :users, :practice_street_1, :string
    add_column :users, :practice_street_2, :string
    add_column :users, :practice_city, :string
    add_column :users, :practice_state, :string
    add_column :users, :practice_zip, :string
  end
end
