class AdminMailer < ApplicationMailer
  default from: ENV.fetch('MAIL_FROM', 'noreply@example.com')

  # Send notification to all admins when a new user registers
  def new_user_registration(user)
    @user = user
    @verification_required = Setting.registration_verification_enabled?
    @verification_url = verify_user_url(token: @user.verification_token) if @verification_required
    
    admin_emails = User.with_role(:admin).pluck(:email)
    
    mail(
      to: admin_emails,
      subject: "New User Registration: #{@user.email}"
    )
  end
end
