class ApplicationController < ActionController::Base
  before_action :set_current_attributes

  def set_current_attributes
    return if controller_name == 'user_sessions'

    return unless spree_current_user.present?

    Current.spree_user = spree_current_user
  end
end
