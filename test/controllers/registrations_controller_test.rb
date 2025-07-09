require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "sign_up_params allows name, email, password, password_confirmation" do
    controller = RegistrationsController.new
    
    # Mock params
    params = ActionController::Parameters.new({
      user: {
        name: "Test User",
        email: "test@example.com", 
        password: "password123",
        password_confirmation: "password123",
        unauthorized_param: "should_not_be_allowed"
      }
    })
    
    controller.params = params
    
    # Test that only allowed parameters are permitted
    allowed_params = controller.send(:sign_up_params)
    
    assert allowed_params.has_key?("name")
    assert allowed_params.has_key?("email")
    assert allowed_params.has_key?("password")
    assert allowed_params.has_key?("password_confirmation")
    assert_not allowed_params.has_key?("unauthorized_param")
  end

  test "account_update_params allows name, email, password, password_confirmation, current_password" do
    controller = RegistrationsController.new
    
    # Mock params
    params = ActionController::Parameters.new({
      user: {
        name: "Updated User",
        email: "updated@example.com",
        password: "newpassword123",
        password_confirmation: "newpassword123", 
        current_password: "oldpassword123",
        unauthorized_param: "should_not_be_allowed"
      }
    })
    
    controller.params = params
    
    # Test that only allowed parameters are permitted
    allowed_params = controller.send(:account_update_params)
    
    assert allowed_params.has_key?("name")
    assert allowed_params.has_key?("email")
    assert allowed_params.has_key?("password")
    assert allowed_params.has_key?("password_confirmation")
    assert allowed_params.has_key?("current_password")
    assert_not allowed_params.has_key?("unauthorized_param")
  end
end
