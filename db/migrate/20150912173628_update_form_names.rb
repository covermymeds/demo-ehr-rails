class UpdateFormNames < ActiveRecord::Migration
  def change
    PaRequest.where(form_name:nil).each do |request|
      request.update_attributes(form_name: "None Chosen")
    end
  end
end
