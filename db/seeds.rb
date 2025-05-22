# This file contains the default seed data for the application.
# It can be loaded with bin/rails db:seed command.

puts "Creating default settings..."

Setting.set(
  'registration_verification_enabled',
  'false',
  description: 'Require admin verification for new user registrations',
  input_type: 'switch'
)

Setting.set(
  'notify_admin_on_registration',
  'true',
  description: 'Send email to administrators when a new user registers',
  input_type: 'switch'
)

puts "Creating default users..."

# Create admin user
admin_email = 'admin@example.com'
admin = User.find_or_initialize_by(email: admin_email)
if admin.new_record?
  admin.password = 'password'
  admin.password_confirmation = 'password'
  admin.first_name = 'System'
  admin.last_name = 'Administrator'
  admin.verified = true
  admin.verified_at = Time.current
  admin.save!
  puts "Admin user created: #{admin_email} (password: password)"
else
  puts "Admin user already exists: #{admin_email}"
  # Update verification status for existing admin
  unless admin.verified?
    admin.update(verified: true, verified_at: Time.current)
    puts "Admin user verification status updated"
  end
end

# Assign admin role
admin.add_role(:admin) unless admin.has_role?(:admin)
puts "Admin role assigned to: #{admin_email}"

# Create regular user
user_email = 'user@example.com'
user = User.find_or_initialize_by(email: user_email)
if user.new_record?
  user.password = 'password'
  user.password_confirmation = 'password'
  user.verified = true
  user.verified_at = Time.current
  user.save!
  puts "Regular user created: #{user_email} (password: password)"
else
  puts "Regular user already exists: #{user_email}"
  # Update verification status for existing regular user
  unless user.verified?
    user.update(verified: true, verified_at: Time.current)
    puts "Regular user verification status updated"
  end
end

puts "Seed data created successfully!"
