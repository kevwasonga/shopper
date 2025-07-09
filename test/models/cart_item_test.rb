require 'test_helper'

class CartItemTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    
    @product = Product.create!(
      title: "Test Product",
      brand: "Ferrari",
      model: "Test Model",
      description: "Test description",
      condition: "New",
      price: 100.00,
      user: @user
    )
    
    @cart = Cart.create!(user: @user)
    @cart_item = CartItem.create!(cart: @cart, product: @product, quantity: 2)
  end

  test "should calculate total price correctly" do
    expected_total = 2 * 100.00
    assert_equal expected_total, @cart_item.total_price
  end

  test "should increase quantity" do
    @cart_item.increase_quantity(3)
    assert_equal 5, @cart_item.quantity
  end

  test "should decrease quantity" do
    @cart_item.decrease_quantity(1)
    assert_equal 1, @cart_item.quantity
  end

  test "should destroy item when quantity reaches zero" do
    assert_difference 'CartItem.count', -1 do
      @cart_item.decrease_quantity(2)
    end
  end

  test "should destroy item when quantity goes below zero" do
    assert_difference 'CartItem.count', -1 do
      @cart_item.decrease_quantity(5)
    end
  end

  test "should require positive quantity" do
    cart_item = CartItem.new(cart: @cart, product: @product, quantity: 0)
    assert_not cart_item.valid?
    assert_includes cart_item.errors[:quantity], "must be greater than 0"
  end

  test "should require cart" do
    cart_item = CartItem.new(product: @product, quantity: 1)
    assert_not cart_item.valid?
    assert_includes cart_item.errors[:cart], "must exist"
  end

  test "should require product" do
    cart_item = CartItem.new(cart: @cart, quantity: 1)
    assert_not cart_item.valid?
    assert_includes cart_item.errors[:product], "must exist"
  end
end
