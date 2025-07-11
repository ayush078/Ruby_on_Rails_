class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :store
  
  # Validations
  validates :rating, presence: true, inclusion: { in: 1..5, message: "must be between 1 and 5" }
  validates :user_id, presence: true
  validates :store_id, presence: true
  validates :user_id, uniqueness: { scope: :store_id, message: "can only rate a store once" }
  
  # Ensure only normal users can rate stores
  validate :user_must_be_normal_user
  validate :user_cannot_rate_own_store
  
  # Scopes
  scope :by_rating, ->(rating_value) { where(rating: rating_value) if rating_value.present? }
  scope :recent, -> { order(created_at: :desc) }
  scope :for_store, ->(store) { where(store: store) }
  scope :by_user, ->(user) { where(user: user) }
  
  # Instance methods
  def user_name
    user&.name
  end
  
  def user_email
    user&.email
  end
  
  def store_name
    store&.name
  end
  
  def rating_text
    case rating
    when 1
      "Poor"
    when 2
      "Fair"
    when 3
      "Good"
    when 4
      "Very Good"
    when 5
      "Excellent"
    else
      "Unknown"
    end
  end
  
  private
  
  def user_must_be_normal_user
    return unless user
    
    unless user.normal_user?
      errors.add(:user, "must be a normal user to rate stores")
    end
  end
  
  def user_cannot_rate_own_store
    return unless user && store
    
    if store.user == user
      errors.add(:base, "cannot rate your own store")
    end
  end
end

