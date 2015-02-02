class AddPrescriberIdToPaRequest < ActiveRecord::Migration
  def change
    add_reference :pa_requests, :prescriber
  end
end
