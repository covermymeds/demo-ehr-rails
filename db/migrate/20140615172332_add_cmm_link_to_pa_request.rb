class AddCmmLinkToPaRequest < ActiveRecord::Migration
  def change
    add_column :pa_requests, :cmm_link, :string
  end
end
