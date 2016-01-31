class PaRequest < ActiveRecord::Base
  belongs_to :prescription, inverse_of: :pa_requests
  belongs_to :patient, inverse_of: :pa_requests
  belongs_to :user, inverse_of: :pa_requests, foreign_key: :prescriber_id
  has_many :cmm_callbacks, inverse_of: :pa_request
  default_scope { where('cmm_token IS NOT NULL') }

  OUTCOME_MAP = {
    unfavorable:  'Denied',
    favorable:    'Approved',
    na:           'Not Needed',
    unsent:       'Unsent',
    cancelled:    'Cancelled',
    unknown:      'Unknown'
  }.freeze

  STATUS_MAP = {
    question_request:     'Request',
    question_response:    'Response',
    pa_request:           'Request',
    pa_response:          'Response',
    appeal_request:       'Request',
    appeal_response:      'Response',
    cancel_request_sent:  'Request',
    provider_cancel:      'Response',
    sent_to_plan:         'Request',
    archived:             'Response'
  }.freeze

  def last_updated
    updated_at.in_time_zone(Time.zone.name)
  end

  def outcome
    outcome = self.cmm_outcome.downcase.parameterize.underscore.to_sym
    OUTCOME_MAP[outcome] || self.cmm_outcome
  end

  def status
    status = self.cmm_workflow_status.downcase.parameterize.underscore.to_sym
    STATUS_MAP[status] || self.cmm_workflow_status
  end

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
