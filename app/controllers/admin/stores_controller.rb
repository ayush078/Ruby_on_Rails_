class Admin::StoresController < ApplicationController
  before_action :require_admin
  before_action :set_store, only: [:show, :edit, :update, :destroy]
  
  def index
    @stores = Store.includes(:user, :ratings)
    
    # Apply filters
    @stores = @stores.where("stores.name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    @stores = @stores.where("stores.email ILIKE ?", "%#{params[:email]}%") if params[:email].present?
    @stores = @stores.where("stores.address ILIKE ?", "%#{params[:address]}%") if params[:address].present?
    
    # Apply sorting
    sort_column = params[:sort] || 'name'
    sort_direction = params[:direction] || 'asc'
    
    case sort_column
    when 'name', 'email', 'address', 'created_at'
      @stores = @stores.order("stores.#{sort_column} #{sort_direction}")
    when 'rating'
      @stores = @stores.left_joins(:ratings)
                      .group('stores.id')
                      .order("AVG(ratings.rating) #{sort_direction}")
    else
      @stores = @stores.order("stores.name asc")
    end
    
    @stores = @stores.page(params[:page])
  end

  def show
    @store_ratings = @store.ratings.includes(:user).order(created_at: :desc)
    @average_rating = @store.average_rating
    @total_ratings = @store.total_ratings
  end

  def new
    @store = Store.new
    @store_owners = User.store_owners.where.not(id: Store.select(:user_id))
  end

  def create
    @store = Store.new(store_params)
    
    if @store.save
      flash[:notice] = "Store created successfully."
      redirect_to admin_stores_path
    else
      flash.now[:alert] = "Error creating store."
      @store_owners = User.store_owners.where.not(id: Store.select(:user_id))
      render :new
    end
  end

  def edit
    @store_owners = User.store_owners.where.not(id: Store.where.not(id: @store.id).select(:user_id))
  end

  def update
    if @store.update(store_params)
      flash[:notice] = "Store updated successfully."
      redirect_to admin_store_path(@store)
    else
      flash.now[:alert] = "Error updating store."
      @store_owners = User.store_owners.where.not(id: Store.where.not(id: @store.id).select(:user_id))
      render :edit
    end
  end

  def destroy
    if @store.destroy
      flash[:notice] = "Store deleted successfully."
    else
      flash[:alert] = "Error deleting store."
    end
    redirect_to admin_stores_path
  end
  
  private
  
  def set_store
    @store = Store.find(params[:id])
  end
  
  def store_params
    params.require(:store).permit(:name, :email, :address, :user_id)
  end
end

