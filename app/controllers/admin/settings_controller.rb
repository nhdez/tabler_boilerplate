class Admin::SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  
  def index
    @settings = Setting.all.order(:name)
  end

  def update
    @setting = Setting.find(params[:id])
    
    if @setting.update(setting_params)
      redirect_to admin_settings_path, notice: "Setting '#{@setting.name}' was successfully updated."
    else
      redirect_to admin_settings_path, alert: "Error updating setting: #{@setting.errors.full_messages.join(', ')}"
    end
  end
  
  private
  
  def setting_params
    params.require(:setting).permit(:value)
  end
  
  def require_admin
    unless current_user.has_role?(:admin)
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
