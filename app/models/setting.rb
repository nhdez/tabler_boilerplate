class Setting < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  
  # Valid input types (for the admin interface)
  VALID_INPUT_TYPES = %w[text number email select checkbox switch datetime color].freeze
  validates :input_type, inclusion: { in: VALID_INPUT_TYPES }
  
  # Class methods for easy access to settings
  class << self
    # Get setting value by name
    def get(name)
      setting = find_by(name: name)
      return nil unless setting
      
      # Convert value based on input type
      case setting.input_type
      when 'checkbox', 'switch'
        ActiveModel::Type::Boolean.new.cast(setting.value)
      when 'number'
        setting.value.to_f
      else
        setting.value
      end
    end
    
    # Update or create a setting
    def set(name, value, description: nil, input_type: 'text')
      setting = find_by(name: name) || new(name: name)
      setting.value = value
      setting.description = description if description
      setting.input_type = input_type if input_type
      setting.save
    end
    
    # Check if registration verification is enabled
    def registration_verification_enabled?
      get('registration_verification_enabled') == true
    end
  end
end
