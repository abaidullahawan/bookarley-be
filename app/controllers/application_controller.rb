# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :set_current_user
  protect_from_forgery
  before_action :configure_permitted_parameters, :configure_sign_up_params,
    :configure_sign_in_params, if: :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(
        :account_update, keys: [
        :name, :nickname, :profile, personal_detail_attributes: [
          :id, :first_name, :last_name, :gender, :dob, :country, :city,
          :username, :phone_number, :language ]
        ]
      )
    end

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys:
        [:email, :password,:phone]
      )
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys:
        [:email, :password, :password_confirmation, :name,:phone]
      )
    end

    def set_current_user
			return if controller_name.eql?('registrations')
      return unless current_api_v1_user.present?
      Current.user = current_api_v1_user
    end
end
