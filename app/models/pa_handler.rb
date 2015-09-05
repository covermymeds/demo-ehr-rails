class PaHandler
  def initialize(pa: pa, user: user, prescription: prescription)
    @user = user
    @pa = pa
    @prescription = prescription
  end

  def call
    if !npi_found?
      :npi_not_found
    elsif !found_prescription?
      :prescription_not_found
    elsif @pa.new_record?
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
end
