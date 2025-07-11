class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  
  def new
    # Login form
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome back, #{user.name}!"
      redirect_based_on_role
    else
      flash.now[:alert] = "Invalid email or password."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out successfully."
    redirect_to login_path
  end
  
  private
  
  def redirect_if_logged_in
    if logged_in?
      redirect_based_on_role
    end
  end
end

