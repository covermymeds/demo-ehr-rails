module LoginHelper
  def login_user(user)
    page.set_rack_session(user_id: user.id)
  end
end

RSpec.configure do |c|
  c.include LoginHelper, type: :feature
end
