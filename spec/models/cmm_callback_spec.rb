require 'rails_helper'

RSpec.describe CmmCallback, type: :model do
  fixtures :cmm_callbacks  
  it { should respond_to(:content)}
  it { should respond_to(:created_at)}
  it { should respond_to(:pa_request)}
end
