class Store < ApplicationRecord
  belongs_to :user
  has_many :ratings, dependent: :destroy
  has_many :rating_users, through: :ratings, source: :user
  
  # Validations
  validates :name, presence: true, length: { minimum: 20, maximum: 60 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true, length: { maximum: 400 }
  validates :user_id, presence: true
  
  # Ensure the associated user is a store owner
  validate :user_must_be_store_owner
  
  # Scopes
  scope :with_ratings, -> { joins(:ratings).distinct }
  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") if name.present? }
  scope :by_address, ->(address) { where("address ILIKE ?", "%#{address}%") if address.present? }
  
  # Instance methods
  def average_rating
    return 0.0 if ratings.empty?
    ratings.average(:rating).round(2)
  end
  
  def total_ratings
    ratings.count
  end
  
  def rating_by_user(user)
    ratings.find_by(user: user)
  end
  
  def rated_by_user?(user)
    ratings.exists?(user: user)
  end
  
  def owner_name
    user&.name
  end
  
  def owner_email
    user&.email
  end
  
  private
  
  def user_must_be_store_owner
    return unless user
    
    unless user.store_owner?
      errors.add(:user, "must be a store owner")
    end
  end
end

