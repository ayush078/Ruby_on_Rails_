class Admin::DashboardController < ApplicationController
  before_action :require_admin
  
  def index
    @total_users = User.count
    @total_stores = Store.count
    @total_ratings = Rating.count
    @total_normal_users = User.normal_users.count
    @total_store_owners = User.store_owners.count
    @total_admins = User.admins.count
    
    # Recent activity
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_stores = Store.order(created_at: :desc).limit(5)
    @recent_ratings = Rating.includes(:user, :store).order(created_at: :desc).limit(10)
    
    # Top rated stores
    @top_rated_stores = Store.joins(:ratings)
                             .group('stores.id')
                             .order('AVG(ratings.rating) DESC')
                             .limit(5)
                             .includes(:user)
  end
end

