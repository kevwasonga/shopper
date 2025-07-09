class ApplicationController < ActionController::Base
    include CurrentCart

    protect_from_forgery with: :exception

    # Make cart_item_count available to all views
    helper_method :cart_item_count
end
