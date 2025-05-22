# Tabler Boilerplate for Rails 8

A production-ready Rails 8 application template with Tabler UI, Devise authentication, role-based authorization, user management, and essential configurations.

## Features

### Core Features
* Rails 8.0.2 with PostgreSQL database
* Horizontal navigation layout (no sidebar)
* Dark mode support with persistent preference
* Responsive design for all device sizes
* Turbo-enabled for SPA-like navigation speed

### Authentication & Authorization
* Devise authentication with styled views
* Rolify for role-based access control
* User management with admin interface
* Profile management with avatar upload
* Optional administrator verification for new accounts

### User Experience
* Avatar support with image upload and fallbacks
* Customizable user profiles (first name, last name, birthdate)
* Tabbed profile pages for better organization
* Flash notifications with styled alerts

### Admin Features
* Admin dashboard with system statistics
* User management (create, edit, block, delete)
* Role assignment and management
* Application settings panel
* Pending user verification queue

## Technical Stack

* **Framework**: Rails 8.0.2
* **Database**: PostgreSQL
* **Frontend Processing**: Vite.js
* **UI Framework**: Tabler UI (Lightweight, modern Bootstrap)
* **Authentication**: Devise with custom views
* **Authorization**: Rolify with custom permissions
* **File Storage**: Active Storage for avatar uploads
* **JavaScript**: Turbo for SPA-like navigation
* **Emails**: SMTP configuration with previews in development

## Setup

### Requirements
* Ruby 3.2+ (recommended: 3.3.0+)
* Node.js 18+ (recommended: 20+)
* PostgreSQL 12+
* Yarn or npm

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/tabler_boilerplate.git
cd tabler_boilerplate
```

2. Install dependencies
```bash
bundle install
yarn install # or npm install
```

3. Setup database
```bash
bin/rails db:create db:migrate db:seed
```

4. Start the development server
```bash
# In one terminal:
bin/rails s

# In another terminal:
bin/vite dev
```

5. Access the application
   - Visit http://localhost:3000
   - Default admin login: `admin@example.com` / `password`
   - Default user login: `user@example.com` / `password`

## Configuration

### Environment Variables

Copy `.env.example` to `.env` and customize for your environment:

```bash
cp .env.example .env
```

### Email Configuration

Email delivery is configured to work with any SMTP provider:

#### Development

In development, emails are caught by the letter_opener gem and displayed in your browser instead of being sent.

You can test emails via the admin interface at `/test_emails/new`.

#### Production

For production, configure your SMTP settings in the `.env` file:

```
# Application settings
APP_HOST=yourdomain.com

# SMTP settings
SMTP_ADDRESS=smtp.yourprovider.com
SMTP_PORT=587
SMTP_DOMAIN=yourdomain.com
SMTP_USERNAME=your_username
SMTP_PASSWORD=your_password
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=true
MAIL_FROM=notifications@yourdomain.com
```

#### Supported Email Providers

The configuration works with any SMTP provider, including:

* Amazon SES
* Mailgun
* SendGrid
* Postmark
* SMTP.com
* Your own SMTP server

See `.env.example` for provider-specific configuration examples.

## User Verification Flow

By default, new user registrations are automatically verified. Admins can enable the verification requirement in the admin settings:

1. Log in as an admin user
2. Navigate to Admin → Settings
3. Enable "Registration verification required"
4. Save the setting

When enabled:
- New users will be redirected to a waiting page after registration
- Admins will receive email notifications of new registrations
- Admins can verify users through the "Pending Verifications" page
- Users will receive an email when their account is verified

## Customization

### Adding New Pages

1. Create a new controller action:
```ruby
# app/controllers/main_controller.rb
def new_page
  # Your logic here
end
```

2. Add the route:
```ruby
# config/routes.rb
get 'new-page', to: 'main#new_page', as: :new_page
```

3. Create the view:
```erb
<!-- app/views/main/new_page.html.erb -->
<div class="page-header">
  <div class="container-xl">
    <h2 class="page-title">New Page</h2>
  </div>
</div>

<div class="page-body">
  <div class="container-xl">
    <!-- Your content here -->
  </div>
</div>
```

### Adding Menu Items

Edit the dashboard layout to add new menu items:

```erb
<!-- app/views/layouts/dashboard.html.erb -->
<li class="nav-item">
  <a class="nav-link" href="<%= new_page_path %>">
    <span class="nav-link-icon d-md-none d-lg-inline-block">
      <!-- SVG icon here -->
    </span>
    <span class="nav-link-title">
      New Page
    </span>
  </a>
</li>
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
