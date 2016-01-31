module PrescriptionsHelper
  def hidden_unless_pa_required(prescription)
    prescription.pa_required? ? '' : 'hidden'
  end

  def hidden_unless_pa_not_required(prescription)
    return 'hidden' if prescription.new_record?
    prescription.pa_required? ? 'hidden' : ''
  end

end
