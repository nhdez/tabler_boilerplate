class TestEmailsController < ApplicationController
  before_action :authorize_admin
  
  def new
  end
  
  def create
    email = params[:email]
    
    if email.present?
      TestMailer.demo_email(email).deliver_now
      redirect_to new_test_email_path, notice: "Test email sent to #{email}! Check your inbox."
    else
      redirect_to new_test_email_path, alert: "Please enter an email address."
    end
  end
  
  private
  
  def authorize_admin
    redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.has_role?(:admin)
  end
end