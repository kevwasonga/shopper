class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  belongs_to :user, optional: true
  
  # Calculate total price of all items in cart
  def total_price
    cart_items.sum { |item| item.quantity * item.product.price }
  end
  
  # Get total number of items in cart
  def total_items
    cart_items.sum(:quantity)
  end
  
  # Add a product to the cart
  def add_product(product, quantity = 1)
    current_item = cart_items.find_by(product: product)
    
    if current_item
      current_item.quantity += quantity
      current_item.save
    else
      cart_items.create(product: product, quantity: quantity)
    end
  end
  
  # Remove a product from the cart
  def remove_product(product)
    cart_items.find_by(product: product)&.destroy
  end
  
  # Empty the entire cart
  def empty_cart
    cart_items.destroy_all
  end
  
  # Check if cart is empty
  def empty?
    cart_items.empty?
  end
end
