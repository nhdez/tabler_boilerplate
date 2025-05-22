class RegistrationsController < Devise::RegistrationsController
  layout :determine_layout
  protect_from_forgery with: :exception
  
  def edit
    # Pass current tab to view if it exists
    @tab = params[:tab]
    super
  end
  
  def create
    super do |resource|
      if resource.persisted? && resource.verification_required?
        # Store the fact that user needs verification in the flash for the redirect
        flash[:verification_required] = true
      end
    end
  end
  
  # Override the redirect after sign up to show waiting page if verification is required
  def after_sign_up_path_for(resource)
    if flash[:verification_required]
      waiting_for_verification_path
    else
      super
    end
  end
  
  # Waiting page for users with pending verification
  def waiting_for_verification
    if user_signed_in? && !current_user.verified? && current_user.verification_token.present?
      render layout: 'devise'
    else
      redirect_to root_path
    end
  end
  
  def update
    # Determine which tab to redirect to based on whether password was included
    password_changed = !params[:user][:password].blank?
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: edit_user_registration_path(tab: password_changed ? 'password' : nil)
    else
      # Redirect to the appropriate tab in case of errors
      tab = password_changed ? 'password' : nil
      redirect_to edit_user_registration_path(tab: tab), alert: resource.errors.full_messages.to_sentence
    end
  end
  
  def update_resource(resource, params)
    # Check if password is provided and call appropriate method
    if params[:password].blank?
      # Delete password-related keys if not updating the password
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      # Password is being updated, need current password
      resource.update_with_password(params)
    end
  end
  
  def remove_avatar
    resource = current_user
    resource.avatar.purge if resource.avatar.attached?
    redirect_to edit_user_registration_path, notice: "Avatar removed successfully."
  end
  
  protected
  
  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, 
                                :avatar, :first_name, :last_name, :birthdate)
  end

  private

  def determine_layout
    if action_name == 'edit' || action_name == 'update' || action_name == 'remove_avatar'
      'dashboard'
    else
      'devise'
    end
  end
end