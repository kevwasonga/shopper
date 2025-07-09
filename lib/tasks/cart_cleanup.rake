namespace :cart do
  desc "Clean up abandoned guest carts older than 7 days"
  task cleanup: :environment do
    # Find guest carts (user_id is nil) that are older than 7 days
    abandoned_carts = Cart.where(user_id: nil)
                         .where('created_at < ?', 7.days.ago)
    
    count = abandoned_carts.count
    
    if count > 0
      abandoned_carts.destroy_all
      puts "Cleaned up #{count} abandoned guest carts"
    else
      puts "No abandoned guest carts found"
    end
  end
  
  desc "Show cart statistics"
  task stats: :environment do
    total_carts = Cart.count
    user_carts = Cart.where.not(user_id: nil).count
    guest_carts = Cart.where(user_id: nil).count
    empty_carts = Cart.joins(:cart_items).group('carts.id').having('COUNT(cart_items.id) = 0').count.size
    
    puts "Cart Statistics:"
    puts "Total carts: #{total_carts}"
    puts "User carts: #{user_carts}"
    puts "Guest carts: #{guest_carts}"
    puts "Empty carts: #{empty_carts}"
  end
end
