class AddStandardXmlsTable < ActiveRecord::Migration
  def change
    create_table :standard_xmls do |t|
      t.string   "filename"
      t.string   "type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
