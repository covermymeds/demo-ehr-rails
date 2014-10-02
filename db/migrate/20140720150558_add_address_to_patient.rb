class AddAddressToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :street_1, :string
    add_column :patients, :street2, :string
    add_column :patients, :city, :string
    add_column :patients, :zip, :string
    add_column :patients, :phone_number, :string
    add_column :patients, :gender, :string
    add_column :patients, :email, :string
  end
end
