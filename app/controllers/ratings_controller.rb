class RatingsController < ApplicationController
  before_action :require_login
  before_action :require_normal_user
  before_action :set_store
  before_action :set_rating, only: [:edit, :update, :destroy]
  before_action :ensure_rating_owner, only: [:edit, :update, :destroy]
  
  def new
    @rating = @store.ratings.build
    
    # Check if user already rated this store
    existing_rating = @store.rating_by_user(current_user)
    if existing_rating
      flash[:alert] = "You have already rated this store. You can edit your existing rating."
      redirect_to edit_store_rating_path(@store, existing_rating)
      return
    end
  end

  def create
    @rating = @store.ratings.build(rating_params)
    @rating.user = current_user
    
    if @rating.save
      flash[:notice] = "Rating submitted successfully!"
      redirect_to @store
    else
      flash.now[:alert] = "Error submitting rating."
      render :new
    end
  end

  def edit
  end

  def update
    if @rating.update(rating_params)
      flash[:notice] = "Rating updated successfully!"
      redirect_to @store
    else
      flash.now[:alert] = "Error updating rating."
      render :edit
    end
  end

  def destroy
    if @rating.destroy
      flash[:notice] = "Rating deleted successfully."
    else
      flash[:alert] = "Error deleting rating."
    end
    redirect_to @store
  end
  
  private
  
  def set_store
    @store = Store.find(params[:store_id])
  end
  
  def set_rating
    @rating = @store.ratings.find(params[:id])
  end
  
  def ensure_rating_owner
    unless @rating.user == current_user
      flash[:alert] = "Access denied."
      redirect_to @store
    end
  end
  
  def rating_params
    params.require(:rating).permit(:rating)
  end
end

