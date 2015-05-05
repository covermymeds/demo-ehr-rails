class AddStandardXmlsTable < ActiveRecord::Migration
  def change
    drop_table 'standard_xmls' if ActiveRecord::Base.connection.table_exists? 'standard_xmls'
  end
end
