class ApplicationController < ActionController::Base
    include CurrentCart

    protect_from_forgery with: :exception

    # Make cart_item_count available to all views
    helper_method :cart_item_count

    # Handle cart merging after user signs in
    before_action :merge_guest_cart_after_sign_in

    private

    def merge_guest_cart_after_sign_in
      if user_signed_in? && session[:cart_id]
        # Force cart merging by calling current_cart
        current_cart
      end
    end
end
