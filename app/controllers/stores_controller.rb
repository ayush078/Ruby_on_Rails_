class StoresController < ApplicationController
  before_action :require_login
  before_action :set_store, only: [:show, :dashboard]
  before_action :require_store_owner_for_dashboard, only: [:dashboard]
  
  def index
    @stores = Store.includes(:user, :ratings)
    
    # Apply search filters
    @stores = @stores.by_name(params[:name]) if params[:name].present?
    @stores = @stores.by_address(params[:address]) if params[:address].present?
    
    # Apply sorting
    sort_column = params[:sort] || 'name'
    sort_direction = params[:direction] || 'asc'
    
    case sort_column
    when 'name', 'address', 'created_at'
      @stores = @stores.order("#{sort_column} #{sort_direction}")
    when 'rating'
      @stores = @stores.left_joins(:ratings)
                      .group('stores.id')
                      .order("AVG(ratings.rating) #{sort_direction}")
    else
      @stores = @stores.order("name asc")
    end
    
    # For normal users, show their ratings
    if current_user.normal_user?
      @user_ratings = current_user.ratings.includes(:store).index_by(&:store_id)
    end
    
    @stores = @stores.page(params[:page])
  end

  def show
    @store_ratings = @store.ratings.includes(:user).order(created_at: :desc)
    @average_rating = @store.average_rating
    @total_ratings = @store.total_ratings
    
    if current_user.normal_user?
      @user_rating = @store.rating_by_user(current_user)
      @can_rate = !@user_rating
    end
  end

  def dashboard
    # Store owner dashboard
    @store_ratings = @store.ratings.includes(:user).order(created_at: :desc)
    @average_rating = @store.average_rating
    @total_ratings = @store.total_ratings
    
    # Statistics
    @ratings_by_score = @store.ratings.group(:rating).count
    @recent_ratings = @store.ratings.includes(:user).order(created_at: :desc).limit(10)
    
    # Monthly ratings trend (last 6 months)
    @monthly_ratings = @store.ratings
                            .where(created_at: 6.months.ago..Time.current)
                            .group_by_month(:created_at)
                            .count
  end
  
  private
  
  def set_store
    @store = Store.find(params[:id])
  end
  
  def require_store_owner_for_dashboard
    unless current_user.store_owner? && current_user.store == @store
      flash[:alert] = "Access denied."
      redirect_to stores_path
    end
  end
end

