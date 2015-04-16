class PaHandler

  def initialize(pa: pa, npi: npi, drug_number: drug_number)
    @npi = npi
    @pa = pa
    @drug_number = drug_number
  end

  def pa_status(status)
    OpenStruct.new(status: status)
  end

  def call
    if !npi_found?
      pa_status(:npi_not_found)
    elsif !found_prescription?
      pa_status(:prescription_not_found)
    elsif @pa.new_record?
      pa_status(:new_retrospective)
    else
      pa_status(:pa_found)
    end
  end

  private
  def npi_found?
    User.where(npi: @npi).any?
  end

  def found_prescription?
    npi_found? && Prescription.where(drug_number: @drug_number).any?
  end

end
