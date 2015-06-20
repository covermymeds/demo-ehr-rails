class PaRequest < ActiveRecord::Base
  belongs_to :prescription
  has_many :cmm_callbacks
  default_scope { where('cmm_token IS NOT NULL') }

  def process_message(message)
    binding.pry
    # message: NCPDP::Document (see ncpdp_epa gem)
    method = {
      NCPDP::InitiationResponse => process_initiation(message),
      NCPDP::Response => process_response(message),
      NCPDP::AppealResponse => process_appeal_response(message),
      NCPDP::CancelResponse => process_cancel_response(message)
    }.fetch(message.class)
    
    save!
  end

  def process_initiation(message)
    binding.pry
    self.cmm_id = message.pa_case_id
    self.note = message.note
    self.cmm_workflow_status = "QuestionResponse"

    if message.response_status.open?
      process_initiation_open(message.response_status.Open)
    elsif message.response_status.closed?
      process_initiation_closed(message.response_status.Closed)
    else
      logger.info "process_initiation: Unknown response received #{message.response_status}"
    end
  end

  def process_initiation_open(open)
    # identify when answers need back
    self.datetime_for_reply = open.DeadlineForReply.DateTime.to_datetime

    # open request messages have question sets
    add_question_set(open.QuestionSet.Header, open.QuestionSet.Questions)
  end

  def process_initiation_closed(closed)

    case closed.ReasonCode
    when "CF"
      self.cmm_outcome = "Favorable"
    when "CC"
      self.cmm_outcome = "PA not required"
    else
      self.cmm_outcome = "Unknown closed reason received"
    end

    # if not closed.AuthorizationPeriod.nil?
    #   self.effective_datetime = closed.AuthorizationPeriod.EffectiveDate.DateTime.to_datetime
    #   self.expiration_datetime = closed.AuthorizationPeriod.ExpirationDate.DateTime.to_datetime
    # end
  end

  def process_response(message)
    self.note = message.pa_note
    self.cmm_workflow_status = "PAResponse"

    if message.approved?
      process_response_approved(message)

    elsif message.open?
      process_response_open(message)

    elsif message.closed? 
      process_response_closed(message)

    elsif message.denied?
      process_response_denied(message)
    end
  end

  def process_response_approved(message)
    self.cmm_outcome = "Favorable"
    self.effective_datetime = message.response_status.Approved.AuthorizationPeriod.EffectiveDate.to_datetime
    self.expiration_datetime = message.response_status.Approved.AuthorizationPeriod.ExpirationDate.to_datetime
  end

  def process_response_open(message)
    reason = message.response_status.Open.Reason
    more_information_required = reason.MoreInformationRequired
    self.cmm_outcome = "Pending"
    self.still_open_reason = reason.OtherReason
    self.datetime_for_reply = more_information_required.DeadlineForReply.DateTime.to_datetime

    # open request messages have question sets
    add_question_set(more_information_required.Header, more_information_required.Questions)
  end    

  def process_response_closed(message)
    self.closed_reason_code = message.response_status.Closed.ClosedReasonCode
    # self.effective_datetime = message.response_status.Closed.AuthorizationPeriod.EffectiveDate.to_datetime
    # self.expiration_datetime = message.response_status.Closed.AuthorizationPeriod.ExpirationDate.to_datetime
  end

  def process_response_denied(message)
    self.cmm_outcome = "Unfavorable"
    self.appeal_supported = message.response_status.Denied.Appeal.IsEAppealSupported
  end

  def process_cancel_response(message)
    self.note = message.note
    if message.approved?
      self.cmm_outcome = "Cancelled"
    else
      self.cancel_denial_reason = message.response_status.Denied.ReasonCode
    end
  end

  #
  # Below here are methods used for the CoverMyMeds API
  #

  def set_cmm_values(response)
    self.cmm_link = response.tokens[0].html_url
    self.cmm_id = response.id
    self.cmm_workflow_status = response.workflow_status || "Not Yet Started"
    self.cmm_outcome = response.plan_outcome || "Undetermined"
    self.cmm_token = response.tokens[0].id
    self.form_id = response.form_id
    self.state = response.state
  end

  def cmm_workflow_status
    read_attribute(:cmm_workflow_status) || "Not Started"
  end

  def cmm_outcome
    read_attribute(:cmm_outcome) || "Unknown"
  end

  def update_from_callback(cb_data)
    self.cmm_link = cb_data['tokens'][0]['html_url']
    self.cmm_id = cb_data['id']
    self.cmm_workflow_status = cb_data['workflow_status'] || "Not Yet Started"
    self.cmm_outcome = cb_data['plan_outcome'] || "Undetermined"
    self.cmm_token = cb_data['tokens'][0]['id']
    self.form_id = cb_data['form_id']
    self.state = cb_data['state']
  end

  def init_from_callback(cb_data)
    self.cmm_link = cb_data['tokens'][0]['html_url']
    self.cmm_id = cb_data['id']
    self.cmm_workflow_status = cb_data['workflow_status'] || "Not Yet Started"
    self.cmm_outcome = cb_data['plan_outcome'] || "Undetermined"
    self.cmm_token = cb_data['tokens'][0]['id']
    self.form_id = cb_data['form_id']
    self.urgent = cb_data['urgent']
    self.state = cb_data['state']

    # look up the patient & prescription, if they exist
    patient_data = cb_data['patient']
    patient = Patient.where(first_name: patient_data['first_name'],
      last_name: patient_data['last_name'],
      date_of_birth: patient_data['date_of_birth']).first

    if patient.nil?
      patient = Patient.create!({
        first_name: cb_data['patient']['first_name'],
        last_name: cb_data['patient']['last_name'],
        state: cb_data['patient']['address']['state'],
        date_of_birth: cb_data['patient']['date_of_birth'],
        street_1: cb_data['patient']['address']['street_1'],
        street_2: cb_data['patient']['address']['street_2'],
        city: cb_data['patient']['address']['city'],
        zip: cb_data['patient']['address']['city'],
        gender: cb_data['patient']['gender'],
        phone_number: cb_data['patient']['phone_number'],
        bin: cb_data['payer']['bin'],
        pcn: cb_data['payer']['pcn'],
        group_id: cb_data['payer']['group_id']
        })
    end

    prescription_data = cb_data['prescription']
    prescription = patient.prescriptions.where(drug_number:prescription_data['drug_id']).order(date_prescribed: :desc).first

    if prescription.nil?
      prescription = Prescription.create!({
        drug_number: cb_data['prescription']['drug_id'],
        drug_name: cb_data['prescription']['name'],
        quantity: cb_data['prescription']['quantity'],
        frequency: cb_data['prescription']['frequency'],
        dispense_as_written: false,
        patient: patient
        })
    end

    self.prescription = prescription
  end

end
