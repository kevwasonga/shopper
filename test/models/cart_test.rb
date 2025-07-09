require 'test_helper'

class CartTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    
    @product1 = Product.create!(
      title: "Test Product 1",
      brand: "Ferrari",
      model: "Test Model 1",
      description: "Test description 1",
      condition: "New",
      price: 100.00,
      user: @user
    )
    
    @product2 = Product.create!(
      title: "Test Product 2",
      brand: "Opel",
      model: "Test Model 2",
      description: "Test description 2",
      condition: "Used",
      price: 50.00,
      user: @user
    )
    
    @cart = Cart.create!(user: @user)
  end

  test "should calculate total price correctly" do
    @cart.add_product(@product1, 2)
    @cart.add_product(@product2, 1)
    
    expected_total = (100.00 * 2) + (50.00 * 1)
    assert_equal expected_total, @cart.total_price
  end

  test "should calculate total items correctly" do
    @cart.add_product(@product1, 2)
    @cart.add_product(@product2, 3)
    
    assert_equal 5, @cart.total_items
  end

  test "should add product to cart" do
    assert_difference '@cart.cart_items.count', 1 do
      @cart.add_product(@product1)
    end
    
    cart_item = @cart.cart_items.first
    assert_equal @product1, cart_item.product
    assert_equal 1, cart_item.quantity
  end

  test "should increase quantity when adding existing product" do
    @cart.add_product(@product1, 2)
    @cart.add_product(@product1, 3)
    
    assert_equal 1, @cart.cart_items.count
    assert_equal 5, @cart.cart_items.first.quantity
  end

  test "should remove product from cart" do
    @cart.add_product(@product1)
    @cart.add_product(@product2)
    
    assert_difference '@cart.cart_items.count', -1 do
      @cart.remove_product(@product1)
    end
    
    assert_not @cart.cart_items.exists?(product: @product1)
    assert @cart.cart_items.exists?(product: @product2)
  end

  test "should empty cart" do
    @cart.add_product(@product1)
    @cart.add_product(@product2)
    
    @cart.empty_cart
    
    assert_equal 0, @cart.cart_items.count
    assert @cart.empty?
  end

  test "should check if cart is empty" do
    assert @cart.empty?
    
    @cart.add_product(@product1)
    assert_not @cart.empty?
  end
end
