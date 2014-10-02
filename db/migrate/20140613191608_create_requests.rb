class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :prescription, index: true
      t.boolean :urgent
      t.string :form_id
      t.string :state
      t.boolean :sent

      t.timestamps
    end
  end
end
