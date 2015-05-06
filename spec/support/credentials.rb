require 'rspec/expectations'

RSpec::Matchers.define :require_at_least_one_credential do
  match do |user|
    user.valid?
    user.errors[:credentials].size > 0
  end
end
