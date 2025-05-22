class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable
         
  # Active Storage for avatar
  has_one_attached :avatar
  
  # Validate avatar content type and size
  validate :validate_avatar, if: -> { avatar.attached? }
  
  # Callbacks
  before_create :set_verification_token, if: :verification_required?
  after_create :notify_admin_of_new_registration, if: :should_notify_admin?
  
  # Scopes for verification
  scope :verified, -> { where(verified: true) }
  scope :unverified, -> { where(verified: false) }
  scope :pending_verification, -> { where(verified: false).where.not(verification_token: nil) }
  
  # Active users for admin dashboard count
  scope :active, -> { where(locked_at: nil) }
  
  # Admin users for dashboard count
  scope :admins, -> { includes(:roles).where(roles: { name: 'admin' }) }
  
  # Name methods
  def full_name
    if first_name.present? || last_name.present?
      [first_name, last_name].compact.join(' ')
    else
      email
    end
  end
  
  def display_name
    first_name.present? ? first_name : email.split('@').first
  end
  
  def validate_avatar
    if !avatar.content_type.in?(%w(image/jpeg image/jpg image/png image/gif))
      errors.add(:avatar, 'must be a JPEG, JPG, PNG, or GIF')
      avatar.purge
    elsif avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, 'is too large (maximum is 5MB)')
      avatar.purge
    end
  end
  
  # Check if a user account is blocked
  def access_locked?
    locked_at.present?
  end
  
  # Verification methods
  def verify!
    update(verified: true, verified_at: Time.current, verification_token: nil)
  end
  
  def verification_required?
    Setting.registration_verification_enabled? && !has_role?(:admin)
  end
  
  def active_for_authentication?
    super && (verified? || !verification_required?)
  end
  
  def inactive_message
    verified? ? super : :unverified
  end
  
  def should_notify_admin?
    Setting.get('notify_admin_on_registration') == true && !has_role?(:admin)
  end
  
  # Get all available roles in the system
  def self.available_roles
    [
      { name: 'admin', description: 'Full access to all system functions and settings' },
      { name: 'manager', description: 'Can manage content and regular users' },
      { name: 'editor', description: 'Can edit content but cannot manage users' },
      { name: 'contributor', description: 'Can create and edit own content only' },
      { name: 'viewer', description: 'Read-only access to protected content' }
    ]
  end
  
  # Check if the user has any role assigned
  def has_any_role?
    roles.any?
  end
  
  # Get the first letter of the email for avatar fallback
  def avatar_letter
    email.first.upcase
  end
  
  # Generate a random color for avatar fallback based on email
  def avatar_color
    colors = [
      "#206bc4", "#4299e1", "#2c3e50", "#2ecc71", "#3498db",
      "#9b59b6", "#34495e", "#16a085", "#27ae60", "#2980b9",
      "#8e44ad", "#f1c40f", "#e67e22", "#e74c3c", "#ecf0f1",
      "#1abc9c", "#f39c12", "#d35400", "#c0392b", "#bdc3c7"
    ]
    
    # Use email to consistently get same color for a user
    colors[Digest::MD5.hexdigest(email.downcase).to_i(16) % colors.length]
  end
  
  private
  
  def set_verification_token
    self.verification_token = SecureRandom.urlsafe_base64(32)
  end
  
  def notify_admin_of_new_registration
    AdminMailer.new_user_registration(self).deliver_later
  end
end
