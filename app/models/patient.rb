class Patient < ActiveRecord::Base
  has_many :prescriptions, dependent: :destroy
  has_many :pa_requests, through: :prescriptions

  validates_presence_of :first_name, :last_name, :state
  validates :date_of_birth, :presence => true, :format => {with: /[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}/, message: "must be DD/MM/YYYY"}

  def full_name
    "#{first_name} #{last_name}"
  end

  def description
    "#{full_name} #{date_of_birth} #{state}"
  end

  def requests
    self.pa_requests.where("cmm_workflow_status IN ('New', 'PA Request', 'Question Request', 'Sent to Plan')").count
  end
end
