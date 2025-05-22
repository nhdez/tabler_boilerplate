class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:verify]
  before_action :require_admin, only: [:verify, :pending_verifications]
  
  # Verification functionality
  def verify
    @user = User.find_by(verification_token: params[:token])
    
    if @user
      @user.verify!
      
      # Send verification email to user
      UserMailer.account_verified(@user).deliver_later
      
      redirect_to admin_users_path, notice: I18n.t('user.verification.success', email: @user.email)
    else
      redirect_to admin_users_path, alert: "Invalid verification token."
    end
  end
  
  def pending_verifications
    @users = User.pending_verification.order(created_at: :desc)
  end
  
  private
  
  def require_admin
    unless current_user && current_user.has_role?(:admin)
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end