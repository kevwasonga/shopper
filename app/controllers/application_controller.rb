class ApplicationController < ActionController::Base
    include CurrentCart

    protect_from_forgery with: :exception

    # Make cart_item_count available to all views
    helper_method :cart_item_count

    # Ensure current_cart is available for all actions
    before_action :set_current_cart

    private

    def set_current_cart
      # This ensures current_cart is initialized for each request
      # The CurrentCart concern handles the logic for guest vs user carts
      current_cart
    end
end
