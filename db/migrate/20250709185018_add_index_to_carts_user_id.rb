class AddIndexToCartsUserId < ActiveRecord::Migration[6.1]
  def change
    # Add index on user_id for faster cart lookups by user
    # This improves performance when finding user's cart
    add_index :carts, :user_id
  end
end
