class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  
  # Calculate total price for this cart item
  def total_price
    quantity * product.price
  end
  
  # Increase quantity by specified amount
  def increase_quantity(amount = 1)
    self.quantity += amount
    save
  end
  
  # Decrease quantity by specified amount
  def decrease_quantity(amount = 1)
    self.quantity -= amount
    if quantity <= 0
      destroy
    else
      save
    end
  end
end
