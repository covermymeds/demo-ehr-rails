class PaHandler

  def initialize(cmm_id: cmm_id, npi: npi, drug_number: drug_number)
    @npi = npi
    # see if the PA exists already in our local database
    @pa = PaRequest.find_by_cmm_id(cmm_id)
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
    elsif !@pa.present?
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
