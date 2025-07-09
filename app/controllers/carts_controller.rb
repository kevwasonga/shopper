class CartsController < ApplicationController
  include CurrentCart
  
  before_action :set_cart, only: [:show, :destroy, :increase_quantity, :decrease_quantity]
  
  # GET /cart
  def show
    @cart_items = @cart.cart_items.includes(:product)
  end
  
  # POST /cart/add_item
  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity]&.to_i || 1
    
    current_cart.add_product(product, quantity)
    
    respond_to do |format|
      format.html { 
        flash[:notice] = "#{product.title} was added to your cart."
        redirect_back(fallback_location: products_path)
      }
      format.json { 
        render json: { 
          message: "Added to cart", 
          cart_count: current_cart.total_items 
        }
      }
    end
  end

  # PATCH /cart/increase_quantity
  def increase_quantity
    product = Product.find(params[:product_id])
    cart_item = current_cart.cart_items.find_by(product: product)

    if cart_item
      cart_item.increase_quantity(1)
      flash[:notice] = "Quantity updated."
    else
      flash[:alert] = "Item not found in cart."
    end

    redirect_to cart_path
  end

  # PATCH /cart/decrease_quantity
  def decrease_quantity
    product = Product.find(params[:product_id])
    cart_item = current_cart.cart_items.find_by(product: product)

    if cart_item
      if cart_item.quantity > 1
        cart_item.decrease_quantity(1)
        flash[:notice] = "Quantity updated."
      else
        # If quantity would become 0, remove the item entirely
        current_cart.remove_product(product)
        flash[:notice] = "#{product.title} was removed from your cart."
      end
    else
      flash[:alert] = "Item not found in cart."
    end

    redirect_to cart_path
  end

  # DELETE /cart/remove_item/:product_id
  def remove_item
    product = Product.find(params[:product_id])
    current_cart.remove_product(product)
    
    respond_to do |format|
      format.html { 
        flash[:notice] = "#{product.title} was removed from your cart."
        redirect_to cart_path
      }
      format.json { 
        render json: { 
          message: "Removed from cart", 
          cart_count: current_cart.total_items 
        }
      }
    end
  end
  
  # DELETE /cart/empty
  def empty
    current_cart.empty_cart
    
    respond_to do |format|
      format.html { 
        flash[:notice] = "Your cart has been emptied."
        redirect_to cart_path
      }
      format.json { 
        render json: { 
          message: "Cart emptied", 
          cart_count: 0 
        }
      }
    end
  end
  
  # DELETE /cart
  def destroy
    @cart.destroy if @cart
    session[:cart_id] = nil
    
    respond_to do |format|
      format.html { 
        flash[:notice] = "Your cart has been cleared."
        redirect_to products_path
      }
      format.json { render json: { message: "Cart cleared" } }
    end
  end
  
  private
  
  def set_cart
    @cart = current_cart
  end
end
