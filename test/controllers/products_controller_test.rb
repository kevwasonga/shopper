require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(
      name: "Test User",
      email: "test@example.com", 
      password: "password123",
      password_confirmation: "password123"
    )
    
    @other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
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
  end

  test "should get index without authentication" do
    get products_url
    assert_response :success
  end

  test "should show product without authentication" do
    get product_url(@product)
    assert_response :success
  end

  test "should require authentication for new product" do
    get new_product_url
    assert_redirected_to new_user_session_path
  end

  test "should allow owner to edit their product" do
    sign_in @user
    get edit_product_url(@product)
    assert_response :success
  end

  test "should not allow non-owner to edit product" do
    sign_in @other_user
    get edit_product_url(@product)
    assert_redirected_to products_path
    assert_equal "You can only edit or delete your own products.", flash[:alert]
  end

  test "should allow owner to update their product" do
    sign_in @user
    patch product_url(@product), params: { 
      product: { 
        title: "Updated Product",
        brand: "Ferrari",
        model: "Updated Model",
        description: "Updated description",
        condition: "Used",
        price: 150.00
      } 
    }
    assert_redirected_to product_url(@product)
    assert_equal "Product was successfully updated.", flash[:notice]
  end

  test "should not allow non-owner to update product" do
    sign_in @other_user
    patch product_url(@product), params: { 
      product: { title: "Hacked Product" } 
    }
    assert_redirected_to products_path
    assert_equal "You can only edit or delete your own products.", flash[:alert]
  end

  test "should allow owner to delete their product" do
    sign_in @user
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end
    assert_redirected_to products_url
    assert_equal "Product was successfully deleted.", flash[:notice]
  end

  test "should not allow non-owner to delete product" do
    sign_in @other_user
    assert_no_difference('Product.count') do
      delete product_url(@product)
    end
    assert_redirected_to products_path
    assert_equal "You can only edit or delete your own products.", flash[:alert]
  end

  test "should create product for authenticated user" do
    sign_in @user
    assert_difference('Product.count') do
      post products_url, params: { 
        product: { 
          title: "New Product",
          brand: "Lenovo",
          model: "New Model",
          description: "New description", 
          condition: "New",
          price: 200.00
        } 
      }
    end
    assert_redirected_to product_url(Product.last)
    assert_equal @user, Product.last.user
  end
end
