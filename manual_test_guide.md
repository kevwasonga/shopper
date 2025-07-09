# Manual Testing Guide for Cart Persistence

This guide will help you manually test the cart persistence functionality to ensure items added to cart before login/signup are preserved after authentication.

## 🧪 Test Scenarios

### Scenario 1: Guest Cart → Sign In
**Objective**: Verify that items added to cart as guest persist after signing in

**Steps**:
1. **Open browser in incognito/private mode** (to ensure clean session)
2. **Navigate to** `http://localhost:3001`
3. **Verify you're not logged in** (should see "Sign In" and "Sign up" buttons)
4. **Add items to cart**:
   - Click "Add to Cart" on any product
   - Notice cart count increases in navigation (e.g., "Cart (1)")
5. **View cart**: Click on "Cart" link
   - Verify items are present in cart
   - Note the items and quantities
6. **Sign in**:
   - Click "Sign In" button
   - Use credentials: `test@example.com` / `password123`
   - Submit form
7. **Verify cart persistence**:
   - Check cart count in navigation (should maintain same count)
   - Click "Cart" link
   - **Expected**: All items from guest cart should be present
   - **Expected**: Flash message: "Welcome back! Your cart items have been restored."

### Scenario 2: Guest Cart → Sign Up
**Objective**: Verify that items added to cart as guest persist after signing up

**Steps**:
1. **Open new incognito/private browser window**
2. **Navigate to** `http://localhost:3001`
3. **Add items to cart** (different items than Scenario 1)
4. **Sign up**:
   - Click "Sign up" button
   - Fill form with new user details:
     - Name: "Test User 2"
     - Email: "test2@example.com"
     - Password: "password123"
     - Password confirmation: "password123"
   - Submit form
5. **Verify cart persistence**:
   - Check cart count in navigation
   - Click "Cart" link
   - **Expected**: All items from guest cart should be present
   - **Expected**: Flash message: "Welcome! Your cart items have been saved to your account."

### Scenario 3: Existing User Cart + Guest Cart Merge
**Objective**: Verify that guest cart items merge with existing user cart items

**Steps**:
1. **Sign in as existing user** (`test@example.com`)
2. **Add some items to cart** while logged in
3. **Sign out**
4. **Add different items to cart** as guest
5. **Sign in again** with same user
6. **Verify cart merge**:
   - **Expected**: Cart should contain both sets of items
   - **Expected**: If same product was in both carts, quantities should be added together
   - **Expected**: Flash message about cart restoration

### Scenario 4: Empty Guest Cart
**Objective**: Verify behavior when guest cart is empty

**Steps**:
1. **Open new incognito window**
2. **Navigate to site** (don't add anything to cart)
3. **Sign in**
4. **Verify**:
   - **Expected**: No cart merge message
   - **Expected**: Cart remains empty or shows existing user cart items

## 🔍 What to Look For

### ✅ Success Indicators
- Cart count in navigation updates correctly
- Items persist across authentication
- Appropriate flash messages appear
- No duplicate items (unless quantities merged)
- Smooth user experience

### ❌ Failure Indicators
- Cart becomes empty after login/signup
- Items duplicated incorrectly
- Error messages or crashes
- Cart count doesn't match actual items
- No feedback to user about cart restoration

## 🛠 Debugging Tips

If tests fail, check:

1. **Server logs** for errors during authentication
2. **Database** for cart and cart_items records:
   ```ruby
   # In rails console
   Cart.all
   CartItem.all
   User.find_by(email: 'test@example.com').cart
   ```
3. **Session data** (check browser developer tools)
4. **Flash messages** for user feedback

## 🔧 Technical Implementation Details

The cart persistence is implemented through:

1. **Custom Sessions Controller** (`Users::SessionsController`)
   - Hooks into Devise's sign-in process
   - Merges guest cart with user cart on successful authentication

2. **Custom Registrations Controller** (`RegistrationsController`)
   - Handles cart transfer during user registration
   - Converts guest cart to user cart

3. **CurrentCart Concern** (`app/models/concerns/current_cart.rb`)
   - Manages cart logic for both guest and authenticated users
   - Handles cart merging operations

4. **Database Structure**:
   - `carts` table with optional `user_id`
   - `cart_items` linking carts to products
   - Index on `user_id` for performance

## 📊 Expected Database Changes

During testing, you should see:

1. **Guest cart creation**: New cart record with `user_id = nil`
2. **After sign-in**: Guest cart deleted, items moved to user cart
3. **After sign-up**: Guest cart updated with `user_id` set to new user

## 🚀 Performance Considerations

The implementation includes:
- Database index on `carts.user_id` for fast lookups
- Efficient cart merging (no N+1 queries)
- Cleanup of abandoned guest carts (via rake task)

---

**Happy Testing! 🛒**
