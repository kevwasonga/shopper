# Shopping Cart Application

A modern, responsive e-commerce shopping cart application built with Ruby on Rails. Features user authentication, product management, and an intuitive shopping cart with icon-based controls.

## Features

- **User Authentication**: Sign up, login, logout functionality
- **Product Management**: Full CRUD operations for products
- **Shopping Cart**: Session-based cart with quantity management
- **Image Upload**: Product image upload with CarrierWave
- **Responsive Design**: Mobile-friendly UI with Bulma CSS framework
- **Intuitive Controls**: Icon-based cart interactions (+ to add, - to remove, trash to delete)
- **Flash Messages**: User feedback for all actions

##  Tech Stack

- **Backend**: Ruby 3.0.0, Rails 6.1.3
- **Database**: SQLite3
- **Frontend**: Bulma CSS Framework, Font Awesome Icons
- **File Upload**: CarrierWave
- **Authentication**: Custom authentication system

##  Prerequisites

Before running this application, make sure you have the following installed:

- Ruby 3.0.0
- Rails 6.1.3
- SQLite3
- Bundler gem
- Git

## 🔧 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/kevwasonga/shopper.git
cd shopper/shop
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Database Setup

```bash
# Create the database
rails db:create

# Run migrations
rails db:migrate

# (Optional) Seed the database with sample data
rails db:seed
```

### 4. Create Upload Directory

```bash
mkdir -p public/uploads
```

##  Running the Application

### Development Server

Start the Rails development server:

```bash
rails server
# or
rails s
```

The application will be available at: `http://localhost:3000`

### Alternative Port

To run on a different port (e.g., 3001):

```bash
rails server -p 3001
```

### Production Mode

To run in production mode:

```bash
RAILS_ENV=production rails server
```

##  Usage

### Getting Started

1. **Visit the Application**: Navigate to `http://localhost:3000`
2. **Sign Up**: Create a new account or login with existing credentials
3. **Browse Products**: View available products on the home page
4. **Add to Cart**: Click "Add to Cart" on any product
5. **Manage Cart**: Use + and - icons to adjust quantities, trash icon to remove items
6. **Checkout**: Review your cart and proceed (checkout functionality can be extended)

### User Authentication

- **Sign Up**: `/users/new`
- **Login**: `/login`
- **Logout**: Click logout in navigation

### Product Management

- **View Products**: `/` (home page)
- **Add Product**: `/products/new` (requires login)
- **Edit Product**: `/products/:id/edit` (requires login)
- **Delete Product**: Available on product show page (requires login)

### Shopping Cart

- **View Cart**: `/cart`
- **Add Item**: Click "Add to Cart" on product pages
- **Increase Quantity**: Click + icon in cart
- **Decrease Quantity**: Click - icon in cart
- **Remove Item**: Click trash icon in cart
- **Empty Cart**: Click "Empty Cart" button

##  Project Structure

```
shop/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── carts_controller.rb
│   │   ├── products_controller.rb
│   │   ├── sessions_controller.rb
│   │   └── users_controller.rb
│   ├── models/
│   │   ├── cart.rb
│   │   ├── cart_item.rb
│   │   ├── product.rb
│   │   └── user.rb
│   ├── views/
│   │   ├── carts/
│   │   ├── products/
│   │   ├── sessions/
│   │   ├── users/
│   │   └── layouts/
│   └── uploaders/
│       └── image_uploader.rb
├── config/
│   ├── routes.rb
│   └── database.yml
├── db/
│   └── migrate/
├── public/
│   └── uploads/
└── README.md
```

## Common Commands

### Database Commands

```bash
# Reset database
rails db:drop db:create db:migrate

# Check migration status
rails db:migrate:status

# Rollback last migration
rails db:rollback

# Run specific migration
rails db:migrate:up VERSION=20231201000000
```

### Rails Console

```bash
# Open Rails console
rails console
# or
rails c

# In console, you can interact with models:
User.all
Product.count
Cart.first
```

### Testing

```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/user_test.rb

# Run tests with verbose output
rails test -v
```

### Code Quality

```bash
# Check for security vulnerabilities
bundle audit

# Update gems
bundle update

# Check outdated gems
bundle outdated
```

##  Customization

### Styling

The application uses Bulma CSS framework. To customize styles:

1. Edit `app/assets/stylesheets/application.css`
2. Add custom CSS classes
3. Modify Bulma variables if needed

### Adding New Features

1. Generate new controller: `rails generate controller ControllerName`
2. Generate new model: `rails generate model ModelName`
3. Create migration: `rails generate migration MigrationName`
4. Add routes in `config/routes.rb`

##  Troubleshooting

### Common Issues

1. **Port already in use**: Kill the process or use a different port
   ```bash
   lsof -ti:3000 | xargs kill -9
   rails server -p 3001
   ```

2. **Database locked**: Reset the database
   ```bash
   rails db:reset
   ```

3. **Missing gems**: Reinstall dependencies
   ```bash
   bundle install
   ```

4. **Image upload issues**: Check upload directory permissions
   ```bash
   chmod 755 public/uploads
   ```

5. **MiniMagick errors**: Image processing is disabled by default for stability
   - Images are uploaded without processing
   - CSS handles responsive sizing

##  API Endpoints

### Authentication
- `GET /login` - Login form
- `POST /login` - Process login
- `DELETE /logout` - Logout user
- `GET /users/new` - Registration form
- `POST /users` - Create user account

### Products
- `GET /` - List all products (home page)
- `GET /products/new` - New product form
- `POST /products` - Create product
- `GET /products/:id` - Show product
- `GET /products/:id/edit` - Edit product form
- `PATCH /products/:id` - Update product
- `DELETE /products/:id` - Delete product

### Shopping Cart
- `GET /cart` - View cart
- `POST /cart/add_item` - Add item to cart
- `PATCH /cart/increase_quantity` - Increase item quantity
- `PATCH /cart/decrease_quantity` - Decrease item quantity
- `DELETE /cart/remove_item/:product_id` - Remove item from cart
- `DELETE /cart/empty` - Empty entire cart

##  Security Features

- Password encryption using BCrypt
- Session-based authentication
- CSRF protection enabled
- SQL injection protection through ActiveRecord
- XSS protection through Rails helpers

##  Database Schema

### Users Table
- `id` (Primary Key)
- `name` (String)
- `email` (String, Unique)
- `password_digest` (String)
- `created_at`, `updated_at` (Timestamps)

### Products Table
- `id` (Primary Key)
- `title` (String)
- `description` (Text)
- `price` (Decimal)
- `condition` (String)
- `image` (String - file path)
- `user_id` (Foreign Key)
- `created_at`, `updated_at` (Timestamps)

### Carts Table
- `id` (Primary Key)
- `created_at`, `updated_at` (Timestamps)

### Cart Items Table
- `id` (Primary Key)
- `cart_id` (Foreign Key)
- `product_id` (Foreign Key)
- `quantity` (Integer)
- `created_at`, `updated_at` (Timestamps)

##  Deployment

### Heroku Deployment

1. Install Heroku CLI
2. Create Heroku app:
   ```bash
   heroku create your-app-name
   ```
3. Add PostgreSQL addon:
   ```bash
   heroku addons:create heroku-postgresql:hobby-dev
   ```
4. Deploy:
   ```bash
   git push heroku main
   heroku run rails db:migrate
   ```

### Environment Variables

For production deployment, set these environment variables:
- `SECRET_KEY_BASE` - Rails secret key
- `DATABASE_URL` - Database connection string

##  License

This project is open source and available under the [MIT License](LICENSE).

##  Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a Pull Request

##  Support

If you encounter any issues or have questions, please:

1. Check the troubleshooting section above
2. Search existing issues on GitHub
3. Create a new issue with detailed information

---

