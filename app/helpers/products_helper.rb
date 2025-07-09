module ProductsHelper
  def product_author(product)
    if product.user
      product.user.name || product.user.email
    else
      "Unknown seller"
    end
  end

  # Check if current user can edit this product
  def can_edit_product?(product)
    user_signed_in? && current_user == product.user
  end

  # Check if current user can delete this product
  def can_delete_product?(product)
    user_signed_in? && current_user == product.user
  end
end
