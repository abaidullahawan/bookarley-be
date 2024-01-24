class ApplicationController < ActionController::Base
  before_action :set_current_attributes
  helper_method :get_session_expiry_time

  def set_current_attributes
    return if controller_name == 'user_sessions'

    return unless spree_current_user.present?

    Current.spree_user = spree_current_user
  end

  def get_session_expiry_time
    return false unless spree_current_user&.present?
  
    if spree_current_user.remember_created_at.nil?
      return spree_current_user.current_sign_in_at < Time.zone.now + 5.minutes
    end
  
    false
  end
end
