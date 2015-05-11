class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.references :user, index: true
      t.string :fax
      t.boolean :registered_with_cmm, default: false
    end
  end
end
