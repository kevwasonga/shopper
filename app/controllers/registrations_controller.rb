# This must be implemented.
# sign_up_params and account_update_params
class RegistrationsController < Devise::RegistrationsController
  include CurrentCart

  # POST /resource
  def create
    # Store the guest cart ID before registration
    guest_cart_id = session[:cart_id]

    # Call Devise's original create method
    super do |resource|
      # This block runs after successful registration
      if resource.persisted? && guest_cart_id
        merge_guest_cart_on_sign_up(guest_cart_id, resource)
      end
    end
  end

  private

  # Allow additional parameters for sign up
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Allow additional parameters for account update
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def merge_guest_cart_on_sign_up(guest_cart_id, user)
    # Find the guest cart
    guest_cart = Cart.find_by(id: guest_cart_id)
    return unless guest_cart && !guest_cart.empty?

    # Create user's cart and associate it with the user
    guest_cart.update!(user: user)

    # Clear session cart ID since we've transferred ownership
    session[:cart_id] = nil

    # Set flash message to inform user
    flash[:notice] = "Welcome! Your cart items have been saved to your account."
  end
end