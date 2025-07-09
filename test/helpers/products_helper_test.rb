require 'test_helper'

class ProductsHelperTest < ActionView::TestCase
  include Devise::Test::ControllerHelpers

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
    
    @product_without_user = Product.create!(
      title: "Orphan Product",
      brand: "Opel", 
      model: "Test Model",
      description: "Test description",
      condition: "Used",
      price: 50.00,
      user: nil
    )
  end

  test "product_author returns user name when user has name" do
    result = product_author(@product)
    assert_equal "Test User", result
  end

  test "product_author returns user email when user has no name" do
    @user.update!(name: nil)
    result = product_author(@product)
    assert_equal "test@example.com", result
  end

  test "product_author returns 'Unknown seller' when product has no user" do
    result = product_author(@product_without_user)
    assert_equal "Unknown seller", result
  end

  test "can_edit_product? returns true when current user owns product" do
    sign_in @user
    result = can_edit_product?(@product)
    assert result
  end

  test "can_edit_product? returns false when current user does not own product" do
    sign_in @other_user
    result = can_edit_product?(@product)
    assert_not result
  end

  test "can_edit_product? returns false when user is not signed in" do
    result = can_edit_product?(@product)
    assert_not result
  end

  test "can_delete_product? returns true when current user owns product" do
    sign_in @user
    result = can_delete_product?(@product)
    assert result
  end

  test "can_delete_product? returns false when current user does not own product" do
    sign_in @other_user
    result = can_delete_product?(@product)
    assert_not result
  end

  test "can_delete_product? returns false when user is not signed in" do
    result = can_delete_product?(@product)
    assert_not result
  end
end
