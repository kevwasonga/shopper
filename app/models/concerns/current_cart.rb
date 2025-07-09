module CurrentCart
  extend ActiveSupport::Concern
  
  private
  
  def current_cart
    @current_cart ||= find_or_create_cart
  end
  
  def find_or_create_cart
    if user_signed_in?
      # For signed-in users, find or create cart associated with user
      current_user_cart = current_user.cart || current_user.create_cart
      
      # If there's a session cart, merge it with user cart
      if session[:cart_id]
        session_cart = Cart.find_by(id: session[:cart_id])
        if session_cart && session_cart != current_user_cart
          merge_carts(session_cart, current_user_cart)
          session_cart.destroy
        end
        session[:cart_id] = nil
      end
      
      current_user_cart
    else
      # For guest users, use session-based cart
      if session[:cart_id]
        cart = Cart.find_by(id: session[:cart_id])
        return cart if cart
      end
      
      # Create new guest cart
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
  end
  
  def merge_carts(source_cart, target_cart)
    source_cart.cart_items.each do |item|
      existing_item = target_cart.cart_items.find_by(product: item.product)
      if existing_item
        existing_item.quantity += item.quantity
        existing_item.save
      else
        item.update(cart: target_cart)
      end
    end
  end
  
  def cart_item_count
    current_cart.total_items
  end
end
