module PrescriptionsHelper
  def hidden_unless_pa_required(prescription)
    prescription.pa_required? ? '' : 'hidden'
  end
end
