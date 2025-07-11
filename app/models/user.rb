class User < ApplicationRecord
  has_secure_password
  
  # Define roles as enum
  enum role: { normal_user: 0, store_owner: 1, system_admin: 2 }
  
  # Associations
  has_many :ratings, dependent: :destroy
  has_one :store, dependent: :destroy
  
  # Validations
  validates :name, presence: true, length: { minimum: 20, maximum: 60 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true, length: { maximum: 400 }
  validates :password, length: { minimum: 8, maximum: 16 }, 
            format: { with: /\A(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).*\z/, 
                     message: "must contain at least one uppercase letter and one special character" },
            if: :password_required?
  validates :role, presence: true
  
  # Scopes
  scope :admins, -> { where(role: 'system_admin') }
  scope :normal_users, -> { where(role: 'normal_user') }
  scope :store_owners, -> { where(role: 'store_owner') }
  
  # Instance methods
  def admin?
    system_admin?
  end
  
  def can_rate_stores?
    normal_user?
  end
  
  def owns_store?
    store_owner? && store.present?
  end
  
  def full_name
    name
  end
  
  def average_rating
    return 0 if store.nil? || store.ratings.empty?
    store.ratings.average(:rating).round(2)
  end
  
  private
  
  def password_required?
    password_digest.blank? || password.present?
  end
end

