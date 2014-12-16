describe "application/_application_navbar.html.erb", :type => :view do

  before do
    render
  end

  it "renders the login text" do
    expect(rendered).to match /Sign in/
  end

  it "renders the Resources text" do
    expect(rendered).to match /Resources/
  end
  
end
