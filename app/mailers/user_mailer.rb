class UserMailer < ApplicationMailer
  default from: "notifications@#{ActionMailer::Base.default_url_options[:host] || 'example.com'}"

  # Email sent to user when their account is verified by an admin
  def account_verified(user)
    @user = user
    @login_url = new_user_session_url
    
    mail(
      to: @user.email,
      subject: "Your Account Has Been Verified"
    )
  end
end
