module DeviseLayout
  extend ActiveSupport::Concern

  included do
    layout :resolve_layout
  end

  private

  def resolve_layout
    if devise_controller?
      'devise'
    else
      user_signed_in? ? 'dashboard' : 'devise'
    end
  end
end