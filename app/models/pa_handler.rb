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
      # systems may choose to reject unrecognized prescriptions, 
      # to create them, or to have a un-attached PA
      # this is the case where a script might have originally been
      # on paper and just the PA is electronic
      :new_retrospective
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
