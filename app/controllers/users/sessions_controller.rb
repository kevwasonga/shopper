# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include CurrentCart
  
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    # Store the guest cart ID before authentication
    guest_cart_id = session[:cart_id]
    
    # Call Devise's original create method
    super do |resource|
      # This block runs after successful authentication
      if resource.persisted? && guest_cart_id
        merge_guest_cart_on_sign_in(guest_cart_id, resource)
      end
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  
  private
  
  def merge_guest_cart_on_sign_in(guest_cart_id, user)
    # Find the guest cart
    guest_cart = Cart.find_by(id: guest_cart_id)
    return unless guest_cart && !guest_cart.empty?
    
    # Find or create user's cart
    user_cart = Cart.find_by(user: user) || Cart.create(user: user)
    
    # Merge guest cart into user cart
    merge_carts(guest_cart, user_cart)
    
    # Clean up guest cart
    guest_cart.destroy
    
    # Clear session cart ID since we've merged it
    session[:cart_id] = nil
    
    # Set flash message to inform user
    flash[:notice] = "Welcome back! Your cart items have been restored."
  end
  
  def merge_carts(source_cart, target_cart)
    return if source_cart.nil? || target_cart.nil?

    source_cart.cart_items.each do |item|
      existing_item = target_cart.cart_items.find_by(product: item.product)
      if existing_item
        # Add quantities together
        existing_item.quantity += item.quantity
        existing_item.save!
      else
        # Move the item to the target cart
        item.update!(cart: target_cart)
      end
    end
  end
end
