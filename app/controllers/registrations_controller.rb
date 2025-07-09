# This must be implemented.
# sign_up_params and account_update_params
class RegistrationsController < Devise::RegistrationsController

 private

  # Allow additional parameters for sign up
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Allow additional parameters for account update
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

end