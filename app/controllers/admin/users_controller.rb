class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_block]

  def index
    @users = User.all.includes(:roles).order(created_at: :desc)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.password = SecureRandom.hex(8) if params[:generate_password]
    generated_password = @user.password if params[:generate_password]

    if @user.save
      assign_roles
      redirect_to admin_user_path(@user), notice: "User was successfully created. #{generated_password ? "Generated password: #{generated_password}" : ""}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      assign_roles
      redirect_to admin_user_path(@user), notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully deleted."
  end

  def toggle_block
    currently_blocked = @user.access_locked?
    
    if currently_blocked
      @user.update(locked_at: nil)
      redirect_to admin_user_path(@user), notice: "User account has been unblocked."
    else
      @user.update(locked_at: Time.current)
      redirect_to admin_user_path(@user), notice: "User account has been blocked."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, 
                                :first_name, :last_name, :birthdate)
  end
  
  def assign_roles
    # Remove existing roles
    @user.roles.destroy_all
    
    # Assign roles based on parameters
    if params[:roles].present?
      params[:roles].each do |role_name, value|
        @user.add_role(role_name.to_sym) if value == "1"
      end
    end
    
    # If no roles were assigned, give the user a default 'viewer' role
    @user.add_role(:viewer) if @user.roles.empty?
  end
end