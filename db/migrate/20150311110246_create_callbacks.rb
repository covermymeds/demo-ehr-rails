class CreateCallbacks < ActiveRecord::Migration
  def change
    create_table :callbacks do |t|
      t.text :content

      t.timestamps
    end
  end
end
