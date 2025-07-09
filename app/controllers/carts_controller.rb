class CartsController < ApplicationController
  include CurrentCart
  
  before_action :set_cart, only: [:show, :destroy]
  
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
