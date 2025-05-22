class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Explicitly enable CSRF protection
  protect_from_forgery with: :exception
  skip_forgery_protection if: -> { request.format.json? }
  
  include DeviseLayout
end
