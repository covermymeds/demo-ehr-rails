class PaHandler
  def initialize(pa, user, prescription, patient)
    @user = user
    @pa = pa
    @prescription = prescription
    @patient = patient
  end

  def call
    if !npi_found?
      :npi_not_found
    elsif !found_prescription?
      :prescription_not_found
    elsif !pa_found?
      :new_retrospective
    else
      :pa_found
    end
  end

  private

  def npi_found?
    @user.present?
  end

  def found_prescription?
    npi_found? && @prescription.present?
  end

  def pa_found?
    @pa.present?
  end
end
