class TestMailer < ApplicationMailer
  default from: ENV.fetch('MAIL_FROM', 'noreply@example.com')

  # Welcome email for new users
  def welcome_email(email)
    @greeting = "Welcome to our application!"
    @app_name = "Tabler Boilerplate"
    @login_url = new_user_session_url
    
    mail(
      to: email,
      subject: "Welcome to #{@app_name}"
    )
  end

  # Test email to demonstrate mail delivery
  def demo_email(email)
    @greeting = "Hello from Tabler Boilerplate!"
    @timestamp = Time.current
    @app_host = ENV.fetch('APP_HOST', 'localhost:3000')
    
    mail(
      to: email,
      subject: "Test Email from Tabler Boilerplate"
    )
  end
end
