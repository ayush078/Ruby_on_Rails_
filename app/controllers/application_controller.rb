class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :current_user
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    !!current_user
  end
  
  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end
  
  def require_admin
    require_login
    unless current_user&.admin?
      flash[:alert] = "You must be an admin to access this page."
      redirect_to root_path
    end
  end
  
  def require_normal_user
    require_login
    unless current_user&.normal_user?
      flash[:alert] = "Access denied."
      redirect_to root_path
    end
  end
  
  def require_store_owner
    require_login
    unless current_user&.store_owner?
      flash[:alert] = "You must be a store owner to access this page."
      redirect_to root_path
    end
  end
  
  def redirect_based_on_role
    return unless logged_in?
    
    case current_user.role
    when 'system_admin'
      redirect_to admin_dashboard_path
    when 'normal_user'
      redirect_to stores_path
    when 'store_owner'
      redirect_to stores_dashboard_path(current_user.store) if current_user.store
    else
      redirect_to root_path
    end
  end
  
  helper_method :current_user, :logged_in?
end

