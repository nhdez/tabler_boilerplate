class AdminController < ApplicationController
  before_action :authorize_admin

  def dashboard
    @users_count = User.count
    @active_users_count = User.active.count
    @admins_count = User.includes(:roles).where(roles: { name: 'admin' }).count
    @managers_count = User.includes(:roles).where(roles: { name: 'manager' }).count
    @editors_count = User.includes(:roles).where(roles: { name: 'editor' }).count
    @contributors_count = User.includes(:roles).where(roles: { name: 'contributor' }).count
    @viewers_count = User.includes(:roles).where(roles: { name: 'viewer' }).count
    @blocked_users_count = @users_count - @active_users_count
  end
  
  private
  
  def authorize_admin
    redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.has_role?(:admin)
  end
end