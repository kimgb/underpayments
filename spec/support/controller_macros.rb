# spec/support/controller_macros.rb
module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:session_admin]
      sign_in create(:session_admin)
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:session_user]
      user = create(:session_user)
      # user.confirm!
      sign_in user
    end
  end
end
