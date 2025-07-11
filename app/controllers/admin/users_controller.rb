class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all
    
    # Apply filters
    @users = @users.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    @users = @users.where("email ILIKE ?", "%#{params[:email]}%") if params[:email].present?
    @users = @users.where("address ILIKE ?", "%#{params[:address]}%") if params[:address].present?
    @users = @users.where(role: params[:role]) if params[:role].present?
    
    # Apply sorting
    sort_column = params[:sort] || 'name'
    sort_direction = params[:direction] || 'asc'
    
    case sort_column
    when 'name', 'email', 'address', 'role', 'created_at'
      @users = @users.order("#{sort_column} #{sort_direction}")
    else
      @users = @users.order("name asc")
    end
    
    @users = @users.includes(:store, :ratings).page(params[:page])
  end

  def show
    @user_ratings = @user.ratings.includes(:store)
    @user_store = @user.store if @user.store_owner?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:notice] = "User created successfully."
      redirect_to admin_users_path
    else
      flash.now[:alert] = "Error creating user."
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User updated successfully."
      redirect_to admin_user_path(@user)
    else
      flash.now[:alert] = "Error updating user."
      render :edit
    end
  end

  def destroy
    if @user == current_user
      flash[:alert] = "You cannot delete yourself."
    elsif @user.destroy
      flash[:notice] = "User deleted successfully."
    else
      flash[:alert] = "Error deleting user."
    end
    redirect_to admin_users_path
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :address, :password, :password_confirmation, :role)
  end
end

