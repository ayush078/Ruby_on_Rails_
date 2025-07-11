class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :change_password, :update_password]
  before_action :ensure_correct_user, only: [:show, :edit, :update, :change_password, :update_password]
  
  def index
    require_admin
    redirect_to admin_users_path
  end

  def show
  end

  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = 'normal_user' # Default role for signup
    
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Account created successfully! Welcome, #{@user.name}!"
      redirect_to stores_path
    else
      flash.now[:alert] = "Error creating account."
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_update_params)
      flash[:notice] = "Profile updated successfully."
      redirect_to @user
    else
      flash.now[:alert] = "Error updating profile."
      render :edit
    end
  end
  
  def change_password
  end
  
  def update_password
    if @user.authenticate(params[:current_password])
      if @user.update(password_params)
        flash[:notice] = "Password updated successfully."
        redirect_to @user
      else
        flash.now[:alert] = "Error updating password."
        render :change_password
      end
    else
      flash.now[:alert] = "Current password is incorrect."
      render :change_password
    end
  end
  
  def dashboard
    require_login
    case current_user.role
    when 'system_admin'
      redirect_to admin_dashboard_path
    when 'normal_user'
      redirect_to stores_path
    when 'store_owner'
      if current_user.store
        redirect_to store_dashboard_path(current_user.store)
      else
        flash[:alert] = "No store associated with your account."
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def ensure_correct_user
    unless @user == current_user || current_user&.admin?
      flash[:alert] = "Access denied."
      redirect_to root_path
    end
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :address, :password, :password_confirmation)
  end
  
  def user_update_params
    params.require(:user).permit(:name, :email, :address)
  end
  
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end

