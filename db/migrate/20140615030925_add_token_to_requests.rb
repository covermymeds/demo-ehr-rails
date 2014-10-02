class AddTokenToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :cmmToken, :string
  end
end
