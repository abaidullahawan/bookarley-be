# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :sign_in_params, if: :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(
        :account_update, keys: [
        :name, :nickname, :profile, personal_detail_attributes: [
          :id, :first_name, :last_name, :gender, :dob, :country, :city, :username, :phone_number, :language
          ]
        ]
      )
    end

    def sign_in_params
      params.permit(user: [:email, :password])
    end
end
