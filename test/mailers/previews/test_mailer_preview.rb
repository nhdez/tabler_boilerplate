# Preview all emails at http://localhost:3000/rails/mailers/test_mailer
class TestMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/test_mailer/welcome_email
  def welcome_email
    TestMailer.welcome_email('test@example.com')
  end

  # Preview this email at http://localhost:3000/rails/mailers/test_mailer/demo_email
  def demo_email
    TestMailer.demo_email('test@example.com')
  end
end
